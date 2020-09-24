<a name=top>
<img align=right src="https://raw.githubusercontent.com/timm/awk/master/etc/img/bubbles.png" width=250>
<h2>
     The Gawk Object Layer
</h2>
<p>
   <a    href="http://menzies.us/awk/index">docs</a>
   :: <a href="http://github.com/timm/awk">code</a>
   :: <a href="http://menzies.us/awk/index#map">map</a>
   :: <a href="http://menzies.us/awk/index#license">license</a>
   :: <a href="http://menzies.us/awk/index#install">install</a>
   :: <a href="http://menzies.us/awk/index#contribute">contrib</a>
   :: <a href="http://github.com/timm/awk/issues">issues</a>
   :: <a href="http://menzies.us/awk/index#cite">cite</a>
   :: <a href="http://menzies.us/awk/index#contact">contact</a>
<br>
   <img src="https://img.shields.io/badge/language-gawk-orange">
   <img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
   <img src="https://img.shields.io/badge/platform-mac,*nux-informational">
</p>

This code is for engineers who want to understand AI. 
- Data is divided, by various means, into populations BEST and REST. 
- The next action is to try something more likely to be BEST than REST. 
- This generates new data, which we use to update BEST and REST.
- Repeat.

To test if you understand those
code, port it to your favorite language then see if you can reproduce the 
demos in `docs/yes*`. Enjoy!

(To make that porting easier, this code is written an simple scripting language
with no prickly features.)

## Map


- Data columns:  num, sym, some, col
- Data rows: row, rows, cols
- Misc: math, string, list, oo
- Boot: gold.awk

## Cite

T. Menzies,  AI made Easy (with GOLD), 2020

## Contact

Tim Menzies, timm@ieee.org, http://menzies.us

## Install

- Download https://github.com/timm/awk/blob/master/gold
- Execute `sh gold`
- Runs some demo; e.g `cd docs; ../gold yesrows.md`

## Contribute

TBD

- Indent= 2 tabs
- Line length = 60 (or if your really need it, 70) characters.
- Use `i` for `self` (its shorter)
- Use `ing` for iterators (who we can type `while(loop(ing))...`)

## License

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to http://unlicense.org/

