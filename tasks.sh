#!/bin/bash

grep -nr --include "*.py" "$1" .
grep -nr --include "*.sh" "$1" .
grep -nr --include "*.R" "$1" .
grep -nr --include "*.tex" "$1" .
