# Marine traffic parser
Extract from vessel detail page latitude, longitude, timestamp and saves to database.
## Usage

```bash
wget -O - -o /dev/null https://www.marinetraffic.com/en/ais/details/ships/shipid:350830/mmsi:273452840/vessel:SHTANDART | ./mtparser.pl 'name_table'
```
or test (print data to stdin, not save to database):

```bash
wget -O - -o /dev/null https://www.marinetraffic.com/en/ais/details/ships/shipid:350830/mmsi:273452840/vessel:SHTANDART | ./mtparser.pl 'name_table' dry
```
## Install

Create table:

```sql
CREATE TABLE 'name_table' (ts int, lat decimal(10,8), lon decimal(11,8));
```
