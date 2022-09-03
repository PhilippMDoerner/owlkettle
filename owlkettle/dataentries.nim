# MIT License
# 
# Copyright (c) 2022 Can Joshua Lehmann
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import std/[strutils]
import widgets, widgetdef, guidsl

proc is_float(value: string): bool =
  if value.len > 0:
    var
      it = 0
      digits = 0
    if value[it] == '+' or value[it] == '-':
      it += 1
    while it < value.len and value[it] in '0'..'9':
      it += 1
      digits += 1
    if it < value.len and value[it] == '.':
      it += 1
      while it < value.len and value[it] in '0'..'9':
        it += 1
        digits += 1
    result = it == value.len and digits > 0

viewable NumberEntry:
  value: float
  current {.internal.}: float
  text {.internal.}: string
  consistent {.internal.}: bool = true
  eps: float = 1e-6
  
  placeholder: string
  width: int = -1
  x_align: float = 0.0
  
  proc changed(value: float)
  
  hooks:
    build:
      state.current = state.value
      state.text = $state.value
      state.consistent = true

method parse(entry: NumberEntryState, text: string): (bool, float) {.base.} =
  if is_float(text):
    result = (true, parse_float(text))

method view*(entry: NumberEntryState): Widget =
  if abs(entry.value - entry.current) > entry.eps:
    entry.current = entry.value
    entry.text = $entry.value
    entry.consistent = true
  result = gui:
    Entry:
      text = entry.text
      
      placeholder = entry.placeholder
      width = entry.width
      x_align = entry.x_align
      
      if entry.consistent:
        style = {}
      else:
        style = {EntryError}
      
      proc changed(text: string) =
        entry.text = text
        let (success, value) = entry.parse(text)
        if success:
          entry.current = value
          entry.value = value
          if not entry.changed.is_nil:
            entry.changed.callback(value)
        entry.consistent = success
      
      proc activate() =
        entry.current = entry.value
        entry.text = $entry.value
        entry.consistent = true

viewable FormulaEntry of NumberEntry:
  discard

method parse(entry: FormulaEntryState, text: string): (bool, float64) =
  type
    TokenKind = enum
      TokenNumber, TokenName, TokenOp, TokenPrefixOp, TokenParOpen, TokenParClose
    
    Token = object
      kind: TokenKind
      value: string
    
    TokenStream = object
      tokens: seq[Token]
      cur: int
  
  proc add(stream: var TokenStream, token: Token) =
    stream.tokens.add(token)
  
  proc next(stream: TokenStream, kind: TokenKind): bool =
    result = stream.cur < stream.tokens.len and
             stream.tokens[stream.cur].kind == kind
  
  proc take(stream: var TokenStream, kind: TokenKind): bool =
    result = stream.next(kind)
    if result:
      stream.cur += 1
  
  proc tokenize(text: string): TokenStream =
    const
      WHITESPACE = {' ', '\n', '\r', '\t'}
      OP = {'+', '-', '*', '/'}
      STOP = {'(', ')'} + OP + WHITESPACE
    var it = 0
    while it < text.len:
      it += 1
      case text[it - 1]:
        of WHITESPACE: discard
        of '(': result.add(Token(kind: TokenParOpen))
        of ')': result.add(Token(kind: TokenParClose))
        of OP:
          var op = $text[it - 1]
          while it < text.len and text[it] in OP:
            op.add(text[it])
            it += 1
          if (op == "+" or op == "-") and
             it < text.len and
             it - 2 >= 0 and
             text[it] notin WHITESPACE and
             text[it - 2] in WHITESPACE:
            result.add(Token(kind: TokenPrefixOp, value: op))
          else:
            result.add(Token(kind: TokenOp, value: op))
        else:
          var name = $text[it - 1]
          while it < text.len and text[it] notin STOP:
            name.add(text[it])
            it += 1
          var kind = TokenName
          if is_float(name):
            kind = TokenNumber
          result.add(Token(kind: kind, value: name))
  
  proc eval(stream: var TokenStream, level: int): tuple[valid: bool, val: float64] =
    var prefix = 1.0
    if stream.take(TokenPrefixOp) and stream.tokens[stream.cur - 1].value == "-":
      prefix = -1.0
    
    if stream.take(TokenNumber):
      let value = stream.tokens[stream.cur - 1].value
      result.valid = value.is_float()
      if result.valid:
        result.val = parse_float(value)
    elif stream.take(TokenParOpen):
      result = stream.eval(0)
      if not stream.take(TokenParClose):
        return (false, 0.0)
    
    if not result.valid:
      return
    
    result.val *= prefix
    
    while stream.take(TokenOp):
      let
        op = stream.tokens[stream.cur - 1].value
        op_level = case op:
          of "+": 0
          of "-": 0
          of "*": 1
          of "/": 1
          else:
            return (false, 0.0)
      if op_level < level:
        stream.cur -= 1
        return
      
      let rhs = stream.eval(op_level + 1)
      if not rhs.valid:
        return (false, 0.0)
      
      result.val = case op:
        of "+": result.val + rhs.val
        of "-": result.val - rhs.val
        of "*": result.val * rhs.val
        of "/": result.val / rhs.val
        else: 0.0
  
  var stream = text.tokenize()
  result = stream.eval(0)
  if stream.cur < stream.tokens.len:
    result[0] = false

export NumberEntry, FormulaEntry
