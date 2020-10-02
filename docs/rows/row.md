```awk
@include "gold"

function Row(i,cells) {
  isa(i,"row")
  has(i,"cells")
  has(i,"cooked")
}
```
