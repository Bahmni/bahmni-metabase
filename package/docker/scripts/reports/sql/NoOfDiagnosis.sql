-- This Source Code Form is subject to the terms of the Mozilla Public License,
-- v. 2.0. If a copy of the MPL was not distributed with this file, You can
-- obtain one at https://www.bahmni.org/license/mplv2hd.
--
-- Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
-- graphic logo is a trademark of OpenMRS Inc.

SELECT vd.coded_diagnosis AS "coded_diagnosis", count(*) AS "count"
FROM visit_diagnoses vd
WHERE (vd.date_created >= (CAST(date_trunc('week', ((now() + (INTERVAL '-1 week')) + (INTERVAL '1 day'))) AS timestamp) + (INTERVAL '-1 day'))
    AND vd.date_created < (CAST(date_trunc('week', (now() + (INTERVAL '1 day'))) AS timestamp) + (INTERVAL '-1 day')))
GROUP BY vd.coded_diagnosis
ORDER BY vd.coded_diagnosis