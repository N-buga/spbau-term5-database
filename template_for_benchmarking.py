from benchmark import *

print "Benchmarking Query 2"
with create_cursor() as cur:
        cur.execute(
#            '''
#            CREATE OR REPLACE VIEW Hosts AS
#            SELECT DISTINCT acc.user_id as host_id FROM Accomodations as acc;
#
#            CREATE OR REPLACE VIEW Renters AS
#            SELECT DISTINCT app.user_id as renter_id FROM Application as app
#            WHERE app.is_accepted = TRUE;
            '''
            prepare plan1 as
            SELECT p.name, p.second_name from People as p
            JOIN 
                (SELECT DISTINCT acc.user_id as host_id FROM Accomodations as acc) AS h
            ON h.host_id = p.id
            JOIN 
                (SELECT DISTINCT app.user_id as renter_id FROM Application as app
                WHERE app.is_accepted = TRUE) AS r ON r.renter_id = p.id;
            '''
                )

	def gen_args():
		return (False,)

	print "Query rate=%f fetched totally %d rows" % query_rate(cur, "execute plan1 (%s)", 101, gen_args)
