#!/bin/bash

# Install presidio_analyzer and presidio_anonymizer
pip install presidio_analyzer
pip install presidio_anonymizer

# Download en_core_web_lg language model for spaCy
python -m spacy download en_core_web_lg  