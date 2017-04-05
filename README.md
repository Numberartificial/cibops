<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#orgb79ce4d">1. plans</a>
<ul>
<li><a href="#orgb3cf966">1.1. optimize page</a>
<ul>
<li><a href="#orge2346dd">1.1.1. <span class="done DONE">DONE</span> get familiar with RemoteData function</a></li>
<li><a href="#org7be3eb4">1.1.2. <span class="done DONE">DONE</span> finish complicate http request</a></li>
</ul>
</li>
<li><a href="#orga3ade0f">1.2. <span class="done DONE">DONE</span> outline</a>
<ul>
<li><a href="#org02d2f15">1.2.1. yes it is outline</a></li>
</ul>
</li>
<li><a href="#org436c8c8">1.3. NEXT</a></li>
<li><a href="#org9b2b100">1.4. <span class="todo TODO">TODO</span> get familiar with org mode</a>
<ul>
<li><a href="#org8ec3ab4">1.4.1. <span class="todo TODO">TODO</span> todo org everyday</a></li>
<li><a href="#org1158034">1.4.2. <span class="todo TODO">TODO</span> write more, think more, hesitate or choose less.</a></li>
</ul>
</li>
</ul>
</li>
<li><a href="#org4d44662">2. elm packages</a>
<ul>
<li><a href="#org223175b">2.1. ohanhi/remotedata-http</a></li>
<li><a href="#org06d708b">2.2. debois/elm-mdl</a>
<ul>
<li><a href="#org9c3676f">2.2.1. UI Framwork</a></li>
</ul>
</li>
</ul>
</li>
<li><a href="#org490aec1">3. special notice</a></li>
</ul>
</div>
</div>

<a id="orgb79ce4d"></a>

# plans


<a id="orgb3cf966"></a>

## optimize page


<a id="orge2346dd"></a>

### get familiar with RemoteData function

remotedata.http use cases: [ComplicateHttp.elm](../src/Try/ComplicateHttp.elm)
CLOSED: <span class="timestamp-wrapper"><span class="timestamp">[2017-03-27 Mon 16:24]</span></span>


<a id="org7be3eb4"></a>

### finish complicate http request

i need to serialize some http requests.

1.  DONE make the flat kind realization.

    Yes, i am looking for a elegant way to chain a list off
    requests; the examples listed in website are all single
    http request.
    Finally, i found this aritical, [elm-chain-http-requests](https://spin.atomicobject.com/2016/10/11/elm-chain-http-requests/),
    plenty of thanks.
      **NOTE**: i've found several place mismatch with nowadays
    elm 0.18.0 version, and i make these overtime codes comment
    in [OrdinaryHttp](../src/Try/OrdinaryHttp.elm).
    Due to this situation, i think *remotedata/http* is **over designed** 
    to omit the elm task concept for asynchronous operations.
    <span class="timestamp-wrapper"><span class="timestamp">&lt;2017-03-28 Tue 11:23&gt;</span></span>

2.  DONE chain requests demo

    1.  DONE {while condition} pattern http requests chain
    
        i need to get a bunch of requests while response is legal.
        
        now i have:
        
        1.  Task
        2.  andThen
        
        taco is something bad for reuse function to
        express a UI component.
        
        taco maybe a misunderstanding of reusable and reliable function.
        i don't wanna use this taco pattern.
    
    2.  DONE there is a elm error     :bug:
    
              CLOSED: <span class="timestamp-wrapper"><span class="timestamp">[2017-03-29 Wed 14:02]</span></span>
             \`\`\` elm-make src/Main.elm
        &#x2013; SYNTAX PROBLEM -------------------------------------&#x2013;&#x2014; ./src/Pages/Ops.elm
        
        I need whitespace, but got stuck on what looks like a new declaration. You are
        either missing some stuff in the declaration above or just need to add some
        spaces here:
        
        I am looking for one of the following things:
        
            whitespace
        \`\`\`
        <span class="timestamp-wrapper"><span class="timestamp">&lt;2017-03-29 Wed 13:59&gt;</span></span>
        i am looking for this weird problem.
        
        i found this commit, thanks for git:
        \`\`\` @@ -240,7 +241,7 @@ viewStargazers taco model =
        
        viewStargazer : Stargazer -> Html Msg
        viewStargazer stargazer =
        
        -   li [ styles (card ++ flexContainer) ]
        -   li [ styles (card ++ flexContainer) 
            [ img
                [ styles avatarPicture
                , src stargazer.avatarUrl
        
        \`\`\` 
        but, this compile warning is ambiguity.

3.  DONE core concept in RemoteData

    It's very clearly that RemoteData is a abstraction of
    Model, not Cmd or Msg.


<a id="orga3ade0f"></a>

## outline

[github](https://github.com/Numberartificial/cibops)


<a id="org02d2f15"></a>

### yes it is outline


<a id="org436c8c8"></a>

## NEXT


<a id="org9b2b100"></a>

## get familiar with org mode


<a id="org8ec3ab4"></a>

### [todo org](./orgman.md) everyday

\#<a id="orgba15b96"></a>
[锚点](#orgba15b96)
**bold**
*italic*
<del>delete</del>
<span class="underline">underline</span>
H<sub>2</sub> O
E = MC<sup>2</sup>
`git`


<a id="org1158034"></a>

### write more, think more, hesitate or choose less.


<a id="org4d44662"></a>

# elm packages


<a id="org223175b"></a>

## ohanhi/remotedata-http


<a id="org06d708b"></a>

## debois/elm-mdl

Material Design Language.


<a id="org9c3676f"></a>

### UI Framwork

It is a ui designe framework of application layer.


<a id="org490aec1"></a>

# special notice

this project is based on [taco](https://github.com/ohanhi/elm-taco) skeleton project, really thanks.

