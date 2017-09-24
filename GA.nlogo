
TURTLES-OWN [dna x y pex fitness pr n new couple couplen whocouple m cross-point altro-dna]
globals [p c d
alfa; costi fissi
beta; costi variabili
a ; intercetta domanda-ineversa
b ; slope domanda-inversa
 ]

to setup
   ca
   create-turtles 1000
   ask turtles [setxy random-xcor random-ycor]
   ask turtles [set color white]
   ask turtles [set dna (list random 2 random 2 random 2 random 2 random 2 random 2 random 2 random 2 random 2 random 2)]
   ask turtles [set x item 0 dna * 2 ^ -1 + item 1 dna  * 2 ^ -2 + item 2 dna  * 2 ^ -3 + item 3 dna  * 2 ^ -4 + item 4 dna  * 2 ^ -5
   + item 5  dna * 2 ^ -6 + item 6 dna  * 2 ^ -7 + item 7 dna  * 2 ^ -8 + item 8 dna  * 2 ^ -9 + item 9 dna  * 2 ^ -10 ]
   
   set alfa 0.25
   set beta 1
   set a 5
   set b 0.005
    
   ask turtles [set y a / (1000 * b) * x] ;a / gamma * x
   set p a - b * sum [y] of turtles
   
   ask turtles [set pex a - b * count turtles * y]
   ask turtles [set fitness pex * y - alfa - y ^ 2  + alfa + beta * ( a / (b * 1000))^ 2 ]
   
END


to go
   if ticks = 500 [stop]
   ;if ticks = 250 [set beta 1.5]
   
   ;set b var-p-y
   set beta variable-cost
   
   selection
   
   
   cross-over
    
    
   mutation
    
   
   
   ;; upgrade parameters
   ask turtles [set x item 0 dna * 2 ^ -1 + item 1 dna  * 2 ^ -2 + item 2 dna  * 2 ^ -3 + item 3 dna  * 2 ^ -4 + item 4 dna  * 2 ^ -5
   + item 5  dna * 2 ^ -6 + item 6 dna  * 2 ^ -7 + item 7 dna  * 2 ^ -8 + item 8 dna  * 2 ^ -9 + item 9 dna  * 2 ^ -10 ]
   
   ask turtles [set y a / (1000 * b) * x]
   set p a - b * sum [y] of turtles
   
   ask turtles [set pex a - b * count turtles * y]
   ask turtles [set fitness p * y - alfa - beta * y ^ 2 + alfa + beta * (a / (1000 * b))^ 2]
   do-plot
   tick
end

to selection
   ask turtles [set n 0]
   ask turtles [set pr fitness / sum [fitness] of turtles]
   while [sum [n] of turtles < 1000] [ask turtles [if random-float 1 < pr [set n n + 1]]]
   ask turtles [if sum [n] of turtles > 1000 [ask n-of (sum [n] of turtles - 1000) turtles with [n > 0][set n n - 1]]]
   ask turtles [hatch n[set new true]]; setxy random-xcor random-ycor]]
   ask turtles [if count turtles with [new = true] > 500[set d count turtles with [new = true] - 1000 ask n-of d turtles [die]]]
   ask turtles with [new != true][die]
   ask turtles [set new false]
end

to cross-over
   ;prima di tutto formo le coppie. sono casuali e danno il valore ad una variabile in modo da essere riconoscibili. gli agenti con lo stesso valore di couplen sono una coppia
    set c 1
    while [count turtles with [couple != true] > 2][ask n-of 2 turtles with [couple != true][set couple true set couplen c] set c c + 1]
    
    ;dico agli agenti il nome del loro partner
    ask turtles [set whocouple [who] of one-of other turtles with [couplen = [couplen] of myself]]
    
    ;le coppie devono stabilire un cross point. Tutti estraggono un numero a caso da 0 a 9, uno dei due si adegua all'altro.
    set c 1
    while [c < max [couplen] of turtles][ask turtles with [couplen = c][set cross-point random 10] ask one-of turtles with [couplen = c] [set cross-point [cross-point] of turtle whocouple set c c + 1]]
    
    ;show [cross-point] of turtles with [couplen = 10]
    ;show [dna] of turtles with [couplen = 10]
    ;show [whocouple] of turtles with [couplen = 10]
    
    ;dico agli agenti il dna del partner. se facessi girare direttamente l'istruzione successiva, il corss over averrebbe effetivamente solo per 
    ;uno dei due agenti, in quanto quando tocca all'altro il primo ha il suo stesso codice genetico dal punto di cross verso destra.
    ;quindi "salvo" il codice del partner in una variabile in modo che ognuno possa fare il suo cross-over.
    ask turtles [set altro-dna [dna] of turtle whocouple]
    
    ;finalmente il cross-over vero e proprio, ogni agente rispetto al cross-point scambia gli ultimi n geni.
    set c 1
    ask turtles [if random-float 1 < 0.6 [if cross-point = 9 [set dna replace-item 0 dna (item 0 altro-dna)] if cross-point >= 8 [set dna replace-item 1 dna (item 1 altro-dna)] 
           if cross-point >= 7 [set dna replace-item 2 dna (item  2 altro-dna)] if cross-point >= 6 [set dna replace-item 3 dna (item 3 altro-dna)] if cross-point >= 5 [set dna replace-item 4 dna (item 4 altro-dna)]
           if cross-point >= 4 [set dna replace-item 5 dna (item 5 altro-dna)] if cross-point >= 3 [set dna replace-item 6 dna (item 6 altro-dna)] if cross-point >= 2 [set dna replace-item 7 dna (item 7 altro-dna)] 
           if cross-point >= 1 [set dna replace-item 8 dna (item 8 altro-dna)] if cross-point >= 0 [set dna replace-item 9 dna (item 9 altro-dna)]]] 
    
    ;show [dna] of turtles with [couplen = 10]
    
    ask turtles [set couplen 0]
    ask turtles [set couple false]
end

to mutation
   ask turtles [while [m < 9][set m m + 1 if random-float 1 < 0.002 [set dna replace-item m dna (1 - item m dna) ]]]
   ask turtles [set m 0]
end

to do-plot
   set-current-plot "Mean output"
   set-current-plot-pen "y"
   plot mean [y] of turtles
   set-current-plot-pen "exy"
   plot a / (2 * beta + 1000 * b)
   
   set-current-plot "variance"
   set-current-plot-pen "variance"
   plot variance [x] of turtles
end
@#$#@#$#@
GRAPHICS-WINDOW
732
10
987
286
16
16
7.424242424242424
1
10
1
1
1
0
1
1
1
-16
16
-16
16
1
1
1
ticks

CC-WINDOW
5
461
996
556
Command Center
0

BUTTON
32
24
101
57
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

MONITOR
17
75
188
124
NIL
mean [y] of turtles\n
17
1
12

MONITOR
17
130
187
179
NIL
mean [fitness] of turtles\n
17
1
12

BUTTON
111
24
174
57
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL

PLOT
216
20
724
415
Mean output
NIL
NIL
0.0
1.0
0.0
1.0
true
false
PENS
"y" 1.0 0 -13345367 true
"exy" 1.0 0 -16777216 true

SLIDER
19
227
191
260
variable-cost
variable-cost
0
10
1
0.1
1
NIL
HORIZONTAL

PLOT
743
297
943
447
variance
NIL
NIL
0.0
10.0
0.0
0.1
true
false
PENS
"variance" 1.0 0 -16777216 true

@#$#@#$#@
WHAT IS IT?
-----------
The model shows an enviroment with 1000 firms that have to choose the quantity to produce. The firms will decide how muche to produce given the costs and the aggregate demand using a genetic algorithm. It is a simple model in which firms are not hyper rational but learn from what the other firms do.
It is slow because it has to do a lot of computation.


HOW IT WORKS
------------
The aggregate demand is given and the producing costs are equal for all firms. The market is competitive, the firms can sell only at the market price. The market price depends, given the demand function, on the overall production. The strategy (how much a generic firm produces) is codified by a binary string. The setup gives to each firm a random strategy. The firms will learn which is the optimal quantity to produce (the same for eache firm since they face equal cost and price) with a genetic algorithm. The black straight line is the optimal production when firms are hyper rational (know everything), the blu line is the mean production. It is interesting to see how the firms converge (quite quickly) towards the optimal rational production. 


HOW TO USE IT
-------------
When you setup the model the firms will have random strategies. The optimal strategy depends on the variable cost. If you change the variable cost the optimal strategy changes and the the firms will converge to the new optimal strategy.


CREDITS AND REFERENCES
----------------------
Jakob Grazzini 2008. jakob.g(at)libero.it
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
