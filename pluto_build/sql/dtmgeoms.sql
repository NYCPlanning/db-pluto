DROP INDEX pbbl_ix;
DROP INDEX dbbl_ix;
CREATE INDEX pbbl_ix
ON pluto (bbl);

CREATE INDEX dbbl_ix
ON pluto_dtm (bbl);