ALL: main.js

main.js: main.opa
	make -C Opa-jquery-ui && opa -I _build main.opa
