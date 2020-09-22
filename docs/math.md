<a name=top>
<h2>
     The Gawk Object Layer
</h2>
<p>
   <a    href="http://menzies.us/awk/index">docs</a>
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

# Misc Maths Stuff

```awk
function max(x,y) { return x>y ? x : y    }
function min(x,y) { return x<y ? x : y    }
function abs(x)   { return x>0 ? x : -1*x }
```

Standard _sample from a Gaussian_ stuff:

```awk
function norm(mu,sd,   w,x1,x2) {
  w  = 1  
  do { 
    x1 = 2.0 * rand() - 1  
    x2 = 2.0 * rand() - 1 
    w  = x1*x1 + x2*x2
  } while (w>=1)
  w = sqrt((-2.0 * log(w))/w);
  return mu + sd * x1 * w;
}
function znorm() { return norm(0,1) }
```
