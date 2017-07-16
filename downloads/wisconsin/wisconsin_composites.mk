# wisconsin_composites.mk
#
# Description: Workflow to create composites for CMMT study
#
# To execute:
#   make -n -B -f wisconsin_composites.mk  (-n is a dry run) (-B is a force make)
#

all : /g/data/r87/dbi599/figures/wisconsin/sf-composite_eraint_500hPa_daily-anom-wrt-all_native-reoriented_marie-byrd.png
REGION=marie-byrd
TITLE=Marie_Byrd_Land

DATA_DIR=/g/data/r87/dbi599/data_eraint/wisconsin_cmmt
VIS_DIR=/home/599/dbi599/climate-analysis/visualisation
PROCESSING_DIR=/home/599/dbi599/climate-analysis/data_processing
WISCONSIN_DIR=/home/599/dbi599/climate-analysis/downloads/wisconsin
PYTHON=/g/data/r87/dbi599/miniconda2/envs/wisconsin/bin/python

DATE_DATA=${WISCONSIN_DIR}/${REGION}_CMMTdatetimes.csv
SF_DATA=${DATA_DIR}/sf_eraint_500hPa_daily-anom-wrt-all_native-reoriented.nc
UA_DATA=${DATA_DIR}/ua_eraint_500hPa_daily_native-reoriented.nc
VA_DATA=${DATA_DIR}/va_eraint_500hPa_daily_native-reoriented.nc

DATE_LIST=${DATA_DIR}/${REGION}_CMMTdatetimes.txt
${DATE_LIST} : 
	${PYTHON} ${WISCONSIN_DIR}/cmmt_date_list.py ${DATE_DATA} $@

SF_COMPOSITE=${DATA_DIR}/sf-composite_eraint_500hPa_daily-anom-wrt-all_native-reoriented_${REGION}.nc
${SF_COMPOSITE} : ${DATE_LIST}
	${PYTHON} ${PROCESSING_DIR}/calc_composite.py ${SF_DATA} sf $@ --date_file $< --no_sig

UA_COMPOSITE=${DATA_DIR}/ua-composite_eraint_500hPa_daily_native-reoriented_${REGION}.nc
${UA_COMPOSITE} : ${DATE_LIST}
	${PYTHON} ${PROCESSING_DIR}/calc_composite.py ${UA_DATA} ua $@ --date_file $< --no_sig

VA_COMPOSITE=${DATA_DIR}/va-composite_eraint_500hPa_daily_native-reoriented_${REGION}.nc
${VA_COMPOSITE} : ${DATE_LIST}
	${PYTHON} ${PROCESSING_DIR}/calc_composite.py ${VA_DATA} va $@ --date_file $< --no_sig

COMPOSITE_PLOT=/g/data/r87/dbi599/figures/wisconsin/sf-composite_eraint_500hPa_daily-anom-wrt-all_native-reoriented_${REGION}.png
${COMPOSITE_PLOT} : ${SF_COMPOSITE} ${UA_COMPOSITE} ${VA_COMPOSITE}
	${PYTHON} ${VIS_DIR}/plot_map.py 3 2 --infile $(word 1,$^) streamfunction_annual none none none contour0 1 PlateCarree --infile $(word 1,$^) streamfunction_DJF none none none contour0 3 PlateCarree --infile $(word 1,$^) streamfunction_MAM none none none contour0 4 PlateCarree --infile $(word 1,$^) streamfunction_JJA none none none contour0 5 PlateCarree --infile $(word 1,$^) streamfunction_SON none none none contour0 6 PlateCarree --output_projection SouthPolarStereo --subplot_headings Annual none DJF MAM JJA SON --infile $(word 2,$^) eastward_wind_annual none none none uwind0 1 PlateCarree --infile $(word 2,$^) eastward_wind_DJF none none none uwind0 3 PlateCarree --infile $(word 2,$^) eastward_wind_MAM none none none uwind0 4 PlateCarree --infile $(word 2,$^) eastward_wind_JJA none none none uwind0 5 PlateCarree --infile $(word 2,$^) eastward_wind_SON none none none uwind0 6 PlateCarree --figure_size 9 16 --infile $(word 3,$^) northward_wind_annual none none none vwind0 1 PlateCarree --infile $(word 3,$^) northward_wind_DJF none none none vwind0 3 PlateCarree --infile $(word 3,$^) northward_wind_MAM none none none vwind0 4 PlateCarree --infile $(word 3,$^) northward_wind_JJA none none none vwind0 5 PlateCarree --infile $(word 3,$^) northward_wind_SON none none none vwind0 6 PlateCarree --flow_type streamlines --contour_levels -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 --exclude_blanks --streamline_colour 0.7 --title ${TITLE} --ofile ${COMPOSITE_PLOT}


