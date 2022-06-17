UPDATE pluto a
SET ownername = trim(regexp_replace(a.ownername, '^([.,;><\-_!?`%]+)(.*)', '\2')),
    dcpedited= 't'
WHERE a.ownername ~ '^([.,;><\-_!?`%]+).*';
