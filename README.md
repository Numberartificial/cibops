<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#orgedd47be">1. plans</a>
<ul>
<li><a href="#org9004040">1.1. optimize page</a>
<ul>
<li><a href="#orgdb013ce">1.1.1. <span class="done DONE">DONE</span> get familiar with RemoteData function</a></li>
<li><a href="#org0014df9">1.1.2. <span class="todo TODO">TODO</span> finish complicate http request</a></li>
</ul>
</li>
<li><a href="#orga7bca10">1.2. <span class="done DONE">DONE</span> outline</a>
<ul>
<li><a href="#org40bd512">1.2.1. yes it is outlineo</a></li>
</ul>
</li>
<li><a href="#orgeb15fe1">1.3. NEXT</a></li>
<li><a href="#org91b7f8f">1.4. <span class="todo TODO">TODO</span> get familiar with org mode</a>
<ul>
<li><a href="#org03ba385">1.4.1. <span class="todo TODO">TODO</span> todo org everyday</a></li>
<li><a href="#org35397fb">1.4.2. <span class="todo TODO">TODO</span> write more, think more, hesitate or choose less.</a></li>
</ul>
</li>
</ul>
</li>
<li><a href="#orge14f742">2. elm packages</a>
<ul>
<li><a href="#orgade892b">2.1. ohanhi/remotedata-http</a></li>
</ul>
</li>
<li><a href="#org4c28c49">3. special notice</a></li>
</ul>
</div>
</div>

<a id="orgedd47be"></a>

# plans


<a id="org9004040"></a>

## optimize page


<a id="orgdb013ce"></a>

### get familiar with RemoteData function

remotedata.http use cases: [ComplicateHttp.elm](../src/Try/ComplicateHttp.elm)
CLOSED: <span class="timestamp-wrapper"><span class="timestamp">[2017-03-27 Mon 16:24]</span></span>


<a id="org0014df9"></a>

### finish complicate http request

i need to serialize some http requests.

1.  TODO make the flat kind realization.

    Yes, i am looking for a elegant way to chain a list off
    requests; the examples listed in website are all single
    http request.
    Finally, i found this aritical, [elm-chain-http-requests](https://spin.atomicobject.com/2016/10/11/elm-chain-http-requests/),
    plenty of thanks.
      **NOTE**: i've found several place mismatch with nowadays
    elm 0.18.0 version, and i make these overtime codes comment
    in [OrdinaryHttp](../src/Try/OrdinaryHttp.elm).
    Due to this situation, i think *remotedata* is **over designed** 
    to omit the elm task concept for asynchronous operations.


<a id="orga7bca10"></a>

## outline

[githu](https://github.com/Numberartificial/cibops)b


<a id="org40bd512"></a>

### yes it is outlineo

iif k
jifei


<a id="orgeb15fe1"></a>

## NEXT


<a id="org91b7f8f"></a>

## get familiar with org mode


<a id="org03ba385"></a>

### [todo org everyday](./orgman.md)

\#<a id="org634d6ba"></a>
[锚点](#org634d6ba)
**bold**
*italic*
<del>delete</del>
<span class="underline">underline</span>
H<sub>2</sub> O
E = MC<sup>2</sup>
`git`


<a id="org35397fb"></a>

### write more, think more, hesitate or choose less.


<a id="orge14f742"></a>

# elm packages


<a id="orgade892b"></a>

## ohanhi/remotedata-http


<a id="org4c28c49"></a>

# special notice

this project is based on [taco](https://github.com/ohanhi/elm-taco) skeleton project, really thanks.

