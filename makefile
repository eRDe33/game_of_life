install:
	chmod +x game_of_life.swift
	
run:
	./game_of_life.swift --input=${FILEPATH} --generationCount=${GENERATIONCOUNT}

