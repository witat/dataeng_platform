DROP TABLE IF EXISTS ds.defect;
CREATE TABLE ds.defect AS
SELECT
	a.createdate as date,
	e.projcode as project_id,
	a.unitcode as unit_id,
	e.projname as project_name,
	a.defect_id,
	b.defectproblemtypedescription as defect_group,
	d.defectproblemdescription as defect_detail,
	case when b.defectproblemtypedescription like '%Zero Defect%' THEN 1 ELSE 0 END AS zerodefect_flag,
	c.defectproblemdetaildescription as defect_place,
	c.projecttype as place_type,
	a.defectstatus
	

FROM
	public.tt_unitdefect a
LEFT JOIN 
	public.tt_mstdefectproblemtype b ON a.defectproblemtype_id = b.defectproblemtype_id
LEFT JOIN 
	public.tt_mstdefectproblemdetailrevise c ON a.defectproblemdetail_id = c.defectproblemdetail_id
LEFT JOIN 
	public.tt_mstdefectproblem d ON a.defectproblem_id = d.defectproblem_id
LEFT JOIN 
	public.tt_projecttracking e ON a.proj_id = e.proj_id
	
WHERE a.defectflagdelete = FALSE
AND c.flagactive = TRUE
ORDER BY a.createdate DESC;
