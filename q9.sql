SELECT 
    Device_Type,
    CASE 
        WHEN INSTR(LOWER(Stats_Access_Link), 'https://') > 0 THEN 
            SUBSTR(Stats_Access_Link, INSTR(Stats_Access_Link, 'https://') + LENGTH('https://'), 
            INSTR(SUBSTR(Stats_Access_Link, INSTR(Stats_Access_Link, 'https://') + LENGTH('https://')), '/') - 2)
        WHEN INSTR(LOWER(Stats_Access_Link), 'http://') > 0 THEN 
            SUBSTR(Stats_Access_Link, INSTR(Stats_Access_Link, 'http://') + LENGTH('http://'), 
            INSTR(SUBSTR(Stats_Access_Link, INSTR(Stats_Access_Link, 'http://') + LENGTH('http://')), '/') - 2)
        ELSE Stats_Access_Link
    END AS Pure_URL
FROM 
    Devices
WHERE 
    Device_Type = 'TRU151';
