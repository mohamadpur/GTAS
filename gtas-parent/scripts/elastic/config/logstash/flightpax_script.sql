    select * from (select
	concat(fp.`passenger_id`,'+',fp.`flight_id`) "id",
	fd.`full_utc_eta_timestamp`  "flight.eta",
	fd.`full_utc_etd_timestamp` "flight.etd",
	f.`created_at` "flight.created_at",
    f.`etd_date` "flight.flight_date",
	f.`carrier`  "flight.carrier",
	f.`flight_number` "flight.flight_number",
	f.`full_flight_number` "flight.full_flight_number",
	f.`id` "flight.id",
	f.`origin` "flight.origin",
	f.`destination` "flight.destination",
	f.`origin_country` "flight.origin_country",
-- 	f.`rule_hit_count` "flight.rule_hit_count",
	-- f.`passenger_count` "flight.passenger_count",
	f.`direction` "flight.direction",

	p.`id` "p_id",
	pd.`pd_nationality` "p_nationality",
	td.`debarkation` "p_debarkation",
	td.`embarkation` "p_embarkation",
	pd.`pd_gender` "p_gender",
	pd.`pd_last_name` "last_name",
	pd.`pd_first_name` "first_name",
	pd.`pd_middle_name` "middle_name",
	pd.`dob` "p_dob",
	pd.`pd_passenger_type` "passenger_type",
	pd.`pd_residency_country` "residency_country",
	seat.`number` "passenger.seat_number",

	d.`document_number` "d_document_number",
	d.`document_type` "d_document_type",
	d.`expiration_date` "d_expiration_date",
	d.`issuance_country` "d_issuance_country",
	d.`issuance_date` "d_issuance_date",
	d.`days_valid` "d_days_valid",
	d.`id` "d_document_id",

	a.id "address.id",
	a.`line1` "address.line1",
	a.`city` "address.city",
	a.`country` "address.country",
	a.`line2` "address.line2",
	a.`line3` "address.line3",
	a.`postal_code` "address.postal_code",
	a.`state` "address.state",
	a.`created_at` "address.created_at",
	a.`created_by` "address.created_by",

	message.`raw` "message",
	message.`create_date` "message.created",

	hit_detail.`id` "hit_detail.id",
	hit_detail.`created_date` "hit_detail.created_date",
	hit_detail.`passenger` "hit_detail.passenger",
	hit_detail.`percentage_match` "hit_detail.percentage_match",
	hit_detail.`hitEnum` "hit_detail.hitEnum"
	-- hit_detail.`watchlist_item_id` "hit_detail.watchlist_item_id"

	from
	`message` message
	join `pnr` pnr
		on (message.id = pnr.id)
	join `pnr_passenger` pnr_p
		on (pnr_p.`passenger_id` = pnr.id)

	join `flight_passenger` fp
        on (pnr_p.`passenger_id` = fp.`passenger_id`)
    join `passenger` p
		on (p.`id` = fp.`passenger_id`)
	join `passenger_details` pd
		on (p.id = pd.pd_passenger_id)
	join `passenger_trip_details` td
		on (td.ptd_id = p.id)
	join `flight` f
		on (fp.`flight_id` = f.`id`)


	left join `mutable_flight_details` fd
		on (f.id = fd.flight_id)
	left join `document` d
		on (d.`passenger_id` = p.id)
	left join `pnr_flight` pnr_f
		on (pnr_f.`flight_id` = fp.`flight_id` and pnr_p.`pnr_id` = pnr_f.`pnr_id`)
	left join pnr_address pnr_a
		on (pnr_a.`pnr_id` = pnr_f.`pnr_id`)
	left join `address` a
		on (a.id = pnr_a.`address_id`)
	left join `hit_detail` hit_detail
		on (hit_detail.passenger=p.id)
	left join seat
		on (seat.flight_id=f.ID and seat.passenger_id=p.id)
 	where message.id >= (select IFNULL(min_id.val, :sql_last_value) from (select MIN(id) as val from message where create_date < (select create_date from message where id=:sql_last_value) and  create_date > (select create_date from message where id=:sql_last_value) - INTERVAL 5 MINUTE) min_id)
 	and message.id < :sql_last_value  + 2000
 	order by p.id DESC) pnr_data

 	union

    select * from (select
	concat(fp.`passenger_id`,'+',fp.`flight_id`) "id",
	fd.`full_utc_eta_timestamp`  "flight.eta",
	fd.`full_utc_etd_timestamp` "flight.etd",
	f.`created_at` "flight.created_at",
    f.`etd_date` "flight.flight_date",
	f.`carrier`  "flight.carrier",
	f.`flight_number` "flight.flight_number",
	f.`full_flight_number` "flight.full_flight_number",
	f.`id` "flight.id",
	f.`origin` "flight.origin",
	f.`destination` "flight.destination",
	f.`origin_country` "flight.origin_country",
-- 	f.`rule_hit_count` "flight.rule_hit_count",
	-- f.`passenger_count` "flight.passenger_count",
	f.`direction` "flight.direction",

	p.`id` "p_id",
	pd.`pd_nationality` "p_nationality",
	td.`debarkation` "p_debarkation",
	td.`embarkation` "p_embarkation",
	pd.`pd_gender` "p_gender",
	pd.`pd_last_name` "last_name",
	pd.`pd_first_name` "first_name",
	pd.`pd_middle_name` "middle_name",
	pd.`dob` "p_dob",
	pd.`pd_passenger_type` "passenger_type",
	pd.`pd_residency_country` "residency_country",
	seat.`number` "passenger.seat_number",

	d.`document_number` "d_document_number",
	d.`document_type` "d_document_type",
	d.`expiration_date` "d_expiration_date",
	d.`issuance_country` "d_issuance_country",
	d.`issuance_date` "d_issuance_date",
	d.`days_valid` "d_days_valid",
	d.`id` "d_document_id",

	NULL AS  "address.id",
	NULL AS  "address.line1",
	NULL AS  "address.city",
	NULL AS  "address.country",
	NULL AS  "address.line2",
	NULL AS  "address.line3",
	NULL AS  "address.postal_code",
	NULL AS  "address.state",
	NULL AS  "address.created_at",
	NULL AS  "address.created_by",

	message.`raw` "message",
	message.`create_date` "message.created",

	hit_detail.`id` "hit_detail.id",
	hit_detail.`created_date` "hit_detail.created_date",
	hit_detail.`passenger` "hit_detail.passenger",
	hit_detail.`percentage_match` "hit_detail.percentage_match",
	hit_detail.`hitEnum` "hit_detail.hitEnum"
	-- hit_detail.`watchlist_item_id` "hit_detail.watchlist_item_id"

	from
	`message` message
	join `apis_message` apis
		on (apis.id = message.id)
	join `apis_message_flight_pax` apis_fp
		on (apis_fp.`apis_message_id` = apis.id)

	join `flight_passenger` fp
        on (apis_fp.`flight_pax_id` = fp.`passenger_id`)
    join `passenger` p
		on (p.`id` = fp.`passenger_id`)
	join `passenger_details` pd
		on (p.id = pd.pd_passenger_id)
	join `passenger_trip_details` td
		on (td.ptd_id = p.id)
	join `flight` f
		on (fp.`flight_id` = f.`id`)


	left join `mutable_flight_details` fd
		on (f.id = fd.flight_id)
	left join `document` d
		on (d.`passenger_id` = p.id)
	left join `hit_detail` hit_detail
		on (hit_detail.passenger=p.id)
	left join seat
		on (seat.flight_id=f.ID and seat.passenger_id=p.id)
 	where message.create_date >= (select IFNULL(min_id.val, :sql_last_value) from (select MIN(id) as val from message where create_date < (select create_date from message where id=:sql_last_value) and  create_date > (select create_date from message where id=:sql_last_value) - INTERVAL 5 MINUTE) min_id)
 	and message.id < :sql_last_value  + 2000
 	order by message.create_date DESC) apis_data