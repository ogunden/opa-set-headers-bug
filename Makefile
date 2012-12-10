ALL: main.js

main.js: main.opa
	make -C Opa-jquery-ui jquery-ui-demo.exe && opa -I Opa-jquery-ui/_build main.opa
