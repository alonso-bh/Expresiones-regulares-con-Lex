#!/bin/bash

#dar permisos con chmod 
flex++ practica2.l

g++ lex.yy.cc -o practica2

./practica2 prueba_mc.txt salida.txt
echo "Todo se ha ejecutado bien"
