#!/bin/bash
# ${parameter:-word} If parameter is unset or null, the expansion of word is substituted. Otherwise, the value of parameter is substituted.

read -p "Enter your name [Richard]: " name
name=${name:-Richard}
echo $name
