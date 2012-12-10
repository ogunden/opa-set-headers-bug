ALL: main.js

main.js: main.opa
	make -C Opa-jquery-ui && opa -I Opa-jquery-ui/_build main.opa
