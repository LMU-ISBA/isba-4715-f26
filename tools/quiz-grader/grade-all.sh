#!/usr/bin/env bash
cd /Users/greglontok/Library/CloudStorage/GoogleDrive-greg@lontok.com/My\ Drive/GitHub/isba-4715-f26/tools/quiz-grader && \
for name in \
  "Che Andrade" \
  "Daniel Lianric Distor" \
  "Eliza Okome" \
  "Eric Timberlake" \
  "Justin Wang" \
  "Leo Chan" \
  "Matthew D'Addio" \
  "Nadia Quek" \
  "Nicholas Chabot" \
  "Quinnlan Medak" \
  "Rachel McDonald" \
  "Sydney Ransel" \
  "Victor Sofelkanik" \
  "Yubin Joe"
do
  echo "========== Grading: $name =========="
  time python grader.py grade -c configs/quiz-01.yaml --student "$name" --no-review --verbose
done
