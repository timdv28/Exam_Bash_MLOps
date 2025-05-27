# Graphics card input, can be overwritten with: make bash GPU=rx6700 for example
GPU ?= rtx3080

.PHONY: tests

bash: 
	bash scripts/collect.sh && \
	bash scripts/preprocessed.sh && \
	bash scripts/train.sh $(GPU)

tests:
	pytest tests/test_collect.py && \
	pytest tests/test_preprocessed.py && \
	pytest tests/test_model.py

all: 