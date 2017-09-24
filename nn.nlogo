breed [input-nodes input-node]                         ;;tre tipi di neuroni, input, nascosti e output
breed [hidden-nodes hidden-node]
breed [output-nodes output-node]

links-own [weight]                                     ;i link possiedono un'unica variabile, il peso del collegamento
globals [errore target-answer]                         ;; errore servirà a calcolare gli errori della rete per sapere quando il training è finito, target answer
                                                        ; serve nella retro propagazione del segnale.
input-nodes-own [activation error] 
output-nodes-own [activation error]
hidden-nodes-own [activation error]                     ; i neuroni hanno due variabili, l'attivazione, che rappresenta il messagio che devono 
                                                        ;spedire tramite i loro link, e l'errore che SERVIRà durante la retro propagazione.
                                                        
                                         

to setup
   ca
   set-default-shape turtles "circle"
   setup-input-nodes
   setup-output-nodes
   setup-hidden-nodes
   setup-links
   do-plot
end

to setup-input-nodes
  
   create-input-nodes 1 [setxy -14 9 set label who]
   create-input-nodes 1 [setxy -14 3 set label who]
   create-input-nodes 1 [setxy -14 -3 set label who]
   create-input-nodes 1 [setxy -14 -9 set label who]
   ask input-nodes [set size 2]
   ask input-nodes [set color blue]
end

to setup-output-nodes
   
   create-output-nodes 1 [setxy 12 9  set label "1"]
   create-output-nodes 1 [setxy 12 6  set label "2"]
   create-output-nodes 1 [setxy 12 3  set label "3"]
   create-output-nodes 1 [setxy 12 0  set label "4"]
   create-output-nodes 1 [setxy 12 -3 set label "5"]
   create-output-nodes 1 [setxy 12 -6 set label "6"]
   create-output-nodes 1 [setxy 12 -9 set label "7"]
    create-output-nodes 1 [setxy 14 9  set label "8"]
   create-output-nodes 1 [setxy 14 6  set label "9"]
   create-output-nodes 1 [setxy 14 3  set label "10"]
   create-output-nodes 1 [setxy 14 0  set label "11"]
   create-output-nodes 1 [setxy 14 -3 set label "12"]
   create-output-nodes 1 [setxy 14 -6 set label "13"]
   create-output-nodes 1 [setxy 14 -9 set label "14"]
   create-output-nodes 1 [setxy 13 -11 set label "15"]
   ask output-nodes [set color red]
end

to setup-hidden-nodes
   
   create-hidden-nodes 1 [setxy -1 10]
   create-hidden-nodes 1 [setxy -1 6]
   create-hidden-nodes 1 [setxy -1 2]
   create-hidden-nodes 1 [setxy -1 -2]
   create-hidden-nodes 1 [setxy -1 -6]
   create-hidden-nodes 1 [setxy -1 -10]
   ask hidden-nodes [set color green]
end
   
to setup-links
   connect-all input-nodes hidden-nodes           ;; colleghiamo i neuroni input con i neuroni nascosti ed i neuroni nascosti con i neuroni output,
   connect-all hidden-nodes output-nodes           ; grazie a link direzionati.
   
end 
   
to connect-all [nodes1 nodes2]
  ask nodes1 [
    create-links-to nodes2 [
      set weight random-float 0.2 - 0.1
    ]
  ]
end

to train
   set errore 0
   repeat esempi-periodo                                   ;;iniziamo il training della rete. al solo scopo di avere una misura dell'apprendimento della rete
   [ask input-nodes [set activation random 2]   
             ; ripetiamo in ogni periodo un numero "esempi-periodo" di esperimenti
   propagate                                                    
   back-propagate
   ]
   set errore errore / esempi-periodo                       ;; ogni periodo conta la percentuale di esempi andati male
   tick
   do-plot
end

to propagate
   ask hidden-nodes [set activation new-activation]
   ask output-nodes [set activation new-activation]
   ask output-nodes [ifelse activation > 0.5 [set color blue][set color white]]
end

to-report new-activation 
  report sigmoid sum [[activation] of end1 * weight] of my-in-links  ;; l'attivazione dei nodi input dipende dall'input, l'attivazione degli altri nodi è la somma 
end                                                                   ; delle attivazioni che viaggiano sui collegamenti in entrata (my-in links), pesato con la forza dei collegamenti ed
                                                                      ; inserito nella funzione sigmoide.
to-report sigmoid [input]
  report 1 / (1 + e ^ (- input))
end
   
to back-propagate
   
   let target [activation] of input-node 0 * 2 ^ 0 + [activation] of input-node 1 * 2 ^ 1 + [activation] of input-node 2 * 2 ^ 2 + [activation] of input-node 3 * 2 ^ 3  
   show target
   if target = 0 [set target-answer [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]]                 ; per la retro porpagazione definisco il risultato target
   if target = 1 [set target-answer [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0]]
   if target = 2 [set target-answer [1 1 0 0 0 0 0 0 0 0 0 0 0 0 0]]
   if target = 3 [set target-answer [1 1 1 0 0 0 0 0 0 0 0 0 0 0 0]]
   if target = 4 [set target-answer [1 1 1 1 0 0 0 0 0 0 0 0 0 0 0]]
   if target = 5 [set target-answer [1 1 1 1 1 0 0 0 0 0 0 0 0 0 0]]
   if target = 6 [set target-answer [1 1 1 1 1 1 0 0 0 0 0 0 0 0 0]]
   if target = 7 [set target-answer [1 1 1 1 1 1 1 0 0 0 0 0 0 0 0]]
   if target = 8 [set target-answer [1 1 1 1 1 1 1 1 0 0 0 0 0 0 0]]
   if target = 9 [set target-answer [1 1 1 1 1 1 1 1 1 0 0 0 0 0 0]]
   if target = 10 [set target-answer [1 1 1 1 1 1 1 1 1 1 0 0 0 0 0]]
   if target = 11 [set target-answer [1 1 1 1 1 1 1 1 1 1 1 0 0 0 0]]
   if target = 12 [set target-answer [1 1 1 1 1 1 1 1 1 1 1 1 0 0 0]]
   if target = 13 [set target-answer [1 1 1 1 1 1 1 1 1 1 1 1 1 0 0]]
   if target = 14 [set target-answer [1 1 1 1 1 1 1 1 1 1 1 1 1 1 0]]
   if target = 15 [set target-answer [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]]
   (foreach target-answer (sort output-nodes)[
         ask ?2 [set error activation * (1 - activation) * (?1 - activation) ] ;; date le due liste target answer ed i nodi output messi in ordine, ho bisogno che il primo elemento 
                                                                                ; della lista target sia uguale all'attivazione. ?1 - activation è la differenza tra il target e l'attivazione del nodo corrispondente ?2
       ])
  
  ask hidden-nodes [
    set error activation * (1 - activation) * sum [weight * [error] of end2] of my-out-links ;; l'errore si propaga indietro verso i neuroni nascosti
  ]
  ask links [
    set weight weight + learning-rate * [error] of end2 * [activation] of end1  ; e va a modificare il peso dei collegamenti.
  ]
  if target != count output-nodes with [color = blue] [set errore errore + 1]  
end

to test
   clear-output
   ask input-node 0 [set activation input-0]     ;; il TEST, l'utente può inserire un umero binario e provare la rete.
   ask input-node 1 [set activation input-1]
   ask input-node 2 [set activation input-2]
   ask input-node 3 [set activation input-3]
   propagate
   output-print "Your binary number is"   
   output-print [activation] of input-node 0 * 2 ^ 0 + [activation] of input-node 1 * 2 ^ 1 + [activation] of input-node 2 * 2 ^ 2 + [activation] of input-node 3 * 2 ^ 3                   
   output-print "The answer of the Neural Network is"   
   output-print count output-nodes with [color = blue]
   ifelse ([activation] of input-node 0 * 2 ^ 0 + [activation] of input-node 1 * 2 ^ 1 + [activation] of input-node 2 * 2 ^ 2 + [activation] of input-node 3 * 2 ^ 3) = count output-nodes with [color = blue]
          [output-print "RIGHT :-)"]
          [output-print "WRONG :-("]
   
end

to do-plot
   set-current-plot "errori"
   set-current-plot-pen "errore"
   if ticks > 0 [plot errore]
   
end
@#$#@#$#@
GRAPHICS-WINDOW
218
10
683
496
16
16
13.8
1
10
1
1
1
0
0
0
1
-16
16
-16
16
0
0
1
ticks

CC-WINDOW
5
511
1076
606
Command Center
0

BUTTON
9
7
72
40
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

BUTTON
9
52
72
85
NIL
train
T
1
T
OBSERVER
NIL
NIL
NIL
NIL

SLIDER
13
121
185
154
learning-rate
learning-rate
0
1
0.2
0.01
1
NIL
HORIZONTAL

CHOOSER
975
58
1067
103
input-0
input-0
0 1
1

CHOOSER
881
58
973
103
input-1
input-1
0 1
1

CHOOSER
788
58
880
103
input-2
input-2
0 1
0

OUTPUT
690
188
983
295
12

TEXTBOX
781
28
1058
56
Inserire il numero binario da convertire
11
0.0
1

BUTTON
700
124
763
157
NIL
test
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

PLOT
690
300
1044
497
errori
periodo
% errori per periodo
0.0
10.0
0.0
1.0
true
false
PENS
"errore" 1.0 0 -16777216 true

SLIDER
13
158
185
191
esempi-periodo
esempi-periodo
1
1000
300
1
1
NIL
HORIZONTAL

CHOOSER
695
58
787
103
input-3
input-3
0 1
1

@#$#@#$#@
WHAT IS IT?
-----------
This is a simple Neural Network. The network learns to convert binary numbers in decimal numbers. A Neural Network is a very simple model of how our brain learn.


HOW IT WORKS
------------
The Neural Network must be trained to work. Given the input the answer of the network will depend on the weight of each link between the nodes. To have the right weights you need to train the network. 
After the setup you can run the training session. In the graph "errori" you can see the number of errors the network does during the training. 
The training consist in the input of 300 example each period (you can change it), the right result is known, so the error can be back-propagated to change the weight of the links between the nodes: the network is learning! 
The errors will decrease to zero. When you like you can test the network, just plug in some number as input and control if the answer of the network is right!


HOW TO USE IT
-------------
You can change the number of examples in each period and change the learning rate, that is how much the network react to an error.


CREDITS AND REFERENCES
----------------------
Jakob Grazzini 2008.
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
