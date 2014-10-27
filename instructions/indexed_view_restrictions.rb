There are several restrictions on the syntax of the view definition. The view definition must not contain the following:

COUNT(*)

ROWSET function

Derived table

self-join

DISTINCT

STDEV, VARIANCE, AVG

Float*, text, ntext, image columns

Subquery

full-text predicates (CONTAIN, FREETEXT)

SUM on nullable expression

MIN, MAX

TOP

OUTER join

UNION