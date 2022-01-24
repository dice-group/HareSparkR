# HareSparkR
Implementation of [HARE](https://svn.aksw.org/papers/2017/ESWC_HARE/public.pdf) algorithm in R in set of functions  `hare.R`.

Trial to use MapReduce to make HARE scalable to datasets of more than 2 Billion triples.
The approach didn't work instead **[incrementalHARE](https://github.com/dice-group/incrementalHARE)** was succeessful to to make HARE scalable to very large knowledge graphs by 1. partioining 2. incremental calculations.

## License

This project is licensed under the
GNU Affero General Public License v3.0.
For the full license text, see [LICENSE](../LICENSE).
