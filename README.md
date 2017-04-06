<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#org585123e">1. plans</a>
<ul>
<li><a href="#orgd4b4116">1.1. optimize page</a>
<ul>
<li><a href="#orgb2b2d86">1.1.1. <span class="done DONE">DONE</span> get familiar with RemoteData function</a></li>
<li><a href="#orge4c2761">1.1.2. <span class="done DONE">DONE</span> finish complicate http request</a></li>
</ul>
</li>
<li><a href="#org2619d80">1.2. <span class="done DONE">DONE</span> outline</a>
<ul>
<li><a href="#orgcf9c56d">1.2.1. yes it is outline</a></li>
</ul>
</li>
<li><a href="#orge6519c1">1.3. NEXT</a>
<ul>
<li><a href="#orgfb56a08">1.3.1. Structural Optimize</a></li>
</ul>
</li>
<li><a href="#org30e97f9">1.4. <span class="todo TODO">TODO</span> get familiar with org mode</a>
<ul>
<li><a href="#org6ce9552">1.4.1. <span class="todo TODO">TODO</span> todo org everyday</a></li>
<li><a href="#orgb896560">1.4.2. <span class="todo TODO">TODO</span> write more, think more, hesitate or choose less.</a></li>
</ul>
</li>
</ul>
</li>
<li><a href="#orgc45fc28">2. elm packages</a>
<ul>
<li><a href="#orgbe463bf">2.1. ohanhi/remotedata-http</a></li>
<li><a href="#orgf09ab58">2.2. debois/elm-mdl</a>
<ul>
<li><a href="#orgedf1d26">2.2.1. UI Framwork</a></li>
</ul>
</li>
</ul>
</li>
<li><a href="#org749ed61">3. work flow</a>
<ul>
<li><a href="#orgc7dfa86">3.1. project version control</a>
<ul>
<li><a href="#org3c7254d">3.1.1. git</a></li>
</ul>
</li>
</ul>
</li>
<li><a href="#orge9fd319">4. special notice</a></li>
</ul>
</div>
</div>


<a id="org585123e"></a>

# plans


<a id="orgd4b4116"></a>

## optimize page


<a id="orgb2b2d86"></a>

### get familiar with RemoteData function

remotedata.http use cases: [ComplicateHttp.elm](../src/Try/ComplicateHttp.elm)
CLOSED: <span class="timestamp-wrapper"><span class="timestamp">[2017-03-27 Mon 16:24]</span></span>


<a id="orge4c2761"></a>

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


<a id="org2619d80"></a>

## outline

[github](https://github.com/Numberartificial/cibops)


<a id="orgcf9c56d"></a>

### yes it is outline


<a id="orge6519c1"></a>

## NEXT


<a id="orgfb56a08"></a>

### Structural Optimize

1.  TODO from top to bottom

2.  TODO no need to consider with reuse , need to abstract.


<a id="org30e97f9"></a>

## get familiar with org mode


<a id="org6ce9552"></a>

### [todo org](./orgman.md) everyday

\#<a id="org58f2fe9"></a>
[锚点](#org58f2fe9)
**bold**
*italic*
<del>delete</del>
<span class="underline">underline</span>
H<sub>2</sub> O
E = MC<sup>2</sup>
`git`


<a id="orgb896560"></a>

### write more, think more, hesitate or choose less.


<a id="orgc45fc28"></a>

# elm packages


<a id="orgbe463bf"></a>

## ohanhi/remotedata-http


<a id="orgf09ab58"></a>

## debois/elm-mdl

Material Design Language.


<a id="orgedf1d26"></a>

### UI Framwork

It is a ui designe framework of application layer.


<a id="org749ed61"></a>

# work flow

  i think it is a very important thing to improve and share the work
flow of a project which i have not seen in other project, much dispointed me.


<a id="orgc7dfa86"></a>

## project version control

i preffer git.


<a id="org3c7254d"></a>

### git

\`\`\`shell 
   git commit -a -m "this is commit info"
   git push
\`\`\` 


<a id="orge9fd319"></a>

# special notice

this project is based on [taco](https://github.com/ohanhi/elm-taco) skeleton project, really thanks.

