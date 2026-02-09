# Quiz 01 Calibration Report

**Quiz:** Quiz 01: Descriptive & Diagnostic Analytics
**Date:** February 9, 2026
**Students analyzed:** 25 (24 in session + 1 report-only: Yubin Joe)
**Session:** quiz-01-20260208-153311

---

## Class Overview (Pre-Calibration)

| Metric | Value |
|--------|-------|
| Mean | 83.2 / 100 (83%) |
| Median | 90.0 |
| Range | 0 -- 97 |

## Criterion Statistics

| Criterion | Max | Mean | Med | SD | %Zero | %Full |
|-----------|-----|------|-----|----|-------|-------|
| SQL query calculates month-over-month change | 5 | 4.6 | 5 | 1.4 | 8% | 92% |
| Correctly identifies order counts and change | 5 | 4.4 | 5 | 1.7 | 12% | 84% |
| Quality of descriptive insight | 10 | 8.1 | 8 | 2.6 | 4% | 44% |
| SQL query compares segments between May | 8 | 7.1 | 8 | 2.3 | 8% | 80% |
| Correctly identifies all 4 segments | 12 | 10.8 | 12 | 2.7 | 4% | 71% |
| Correctly identifies Dorm students as primary | 15 | 13.2 | 14 | 3.1 | 4% | 28% |
| SQL query breaks down orders by time period | 8 | 7.4 | 8 | 1.7 | 4% | 80% |
| Correctly shows Afternoon as biggest decrease | 7 | 6.2 | 7 | 2.1 | 8% | 84% |
| Quality of WHEN diagnostic insight | 10 | 8.1 | 10 | 2.9 | 4% | 52% |
| Synthesizes all three findings into coherent story | 10 | 7.7 | 9 | 3.1 | 8% | 44% |
| Provides actionable recommendation | 5 | 4.0 | 5 | 1.5 | 8% | 60% |
| Provides logical prediction with support | 5 | 2.0 | 2 | 1.0 | 8% | **4%** |

> The prediction criterion is a clear outlier: only 4% of students achieved full marks compared to 44--92% on all other criteria.

---

## Calibration Findings

### Finding 1: Prediction Criterion Too Demanding (confusing_question)

**Criterion:** Provides logical prediction with supporting math (`t4-prediction`)

Only 1 of 25 students (4%) achieved full marks on the prediction criterion, while 72% clustered at exactly 2 points. The rubric requires "quantified prediction with supporting math" but sample feedback shows students understood the concept directionally without providing calculations. This is a dramatic outlier compared to other criteria where 44--92% achieved full marks.

**Recommendation:** For future quizzes, either simplify the prediction rubric or allocate more time for calculation-based questions on a 50-minute assessment.

### Finding 2: Approach-vs-Results Mismatch (notable_pattern)

**Affected student:** Victor Sofelkanik

Victor scored high on approach criteria (7--8/8) but zero on corresponding results criteria. This pattern suggests minor execution errors (typos, off-by-one in time boundaries) rather than conceptual gaps, causing cascading zeros in later synthesis tasks.

**Recommendation:** Review Victor's actual SQL queries for minor fixable errors. Consider whether the rubric should award more partial credit when approach is correct but execution has small errors.

### Finding 3: Scoring Inconsistency (grading_inconsistency)

**Affected student:** Lauren de los Reyes

Lauren scored 0/5 on `t1-sql-approach` and 0/5 on `t1-correct-results`, yet achieved 15/15 on `t2-insight-who` (identifying Dorm students as the primary driver). This is logically inconsistent -- if Task 1 was completely missing, how did she correctly identify the WHO in Task 2?

**Recommendation:** Review Lauren's submission to verify Task 1 scoring. She may have submitted work in an unexpected format, or her Task 2 analysis compensated through alternative reasoning.

---

## Adjustments Applied

### Rubric-Wide Adjustment: Prediction Criterion (+2 points)

**Criterion:** Provides logical prediction with supporting math (`t4-prediction`)
**Points added:** +2 (modified from LLM-proposed +1)
**Rationale:** The prediction criterion mean (40%) was dramatically lower than all other criteria (80%+). With only 1 of 25 students achieving full marks and 72% clustering at exactly 2 points, the "quantified prediction with supporting math" standard was too demanding for a 50-minute timed assessment. Students demonstrated conceptual understanding but lacked time for detailed calculations.

**Impact by original score:**

| Original | Adjusted | Students |
|----------|----------|----------|
| 0 | 2 | 2 (Che Andrade, Victor Sofelkanik) |
| 1 | 3 | 3 (Lauren de los Reyes, Lillian Labra, Matthew D'Addio) |
| 2 | 4 | 15 (majority of class) |
| 3 | 5 | 2 (Alessia Berry, Beckett Yee) |
| 4 | 5 (capped) | 1 (Emma Sprankle) |
| 5 | 5 (unchanged) | 2 (already at max) |

### Student Bump: Victor Sofelkanik

| Criterion | Original | New | Rationale |
|-----------|----------|-----|-----------|
| `t3-correct-results` | 0 | 3 | Scored 7/8 on SQL approach (correct logic) but 0/7 on results, suggesting a minor execution error rather than conceptual misunderstanding. |
| `t4-synthesis` | 0 | 3 | Zero on synthesis cascaded from Task 3 execution error; demonstrated understanding elsewhere (7/8 on T3 approach, identified correct segment and time period). |

### Student Bump: Lauren de los Reyes

| Criterion | Original | New | Rationale |
|-----------|----------|-----|-----------|
| `t1-correct-results` | 0 | 3 | Scored 0 on Task 1 SQL and results but achieved 15/15 on `t2-insight-who`. This exceptional diagnostic performance suggests she may have used an alternative approach or the grader missed her Task 1 work. |

---

## Post-Calibration Impact

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| Class mean | 83.2 | ~85.1 | +1.9 |
| Median | 90.0 | ~92 | +2 |
| Range | 0--97 | 2--99 | narrowed floor |
| Students adjusted | -- | 24 of 24 | rubric-wide prediction bump |
| Individual bumps | -- | 2 students | Victor (+6), Lauren (+3) |

**Total adjustments applied:** 4 (1 rubric-wide + 3 individual bumps)
