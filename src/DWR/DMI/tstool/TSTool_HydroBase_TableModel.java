package DWR.DMI.tstool;

import java.util.List;

import DWR.DMI.HydroBaseDMI.HydroBase_StationGeolocMeasType;
import DWR.DMI.HydroBaseDMI.HydroBase_StructureGeolocStructMeasType;
import DWR.DMI.HydroBaseDMI.HydroBase_WaterDistrict;
import DWR.DMI.HydroBaseDMI.HydroBase_GroundWaterWellsView;

import RTi.DMI.DMIUtil;
import RTi.Util.GUI.JWorksheet;
import RTi.Util.GUI.JWorksheet_AbstractRowTableModel;

/**
This class is a table model for time series header information for HydroBase station and structure
time series.  By default the sheet will contain row and column numbers.
*/
public class TSTool_HydroBase_TableModel
extends JWorksheet_AbstractRowTableModel
{

/**
Number of columns in the table model, including the row number.
*/
private final int __COLUMNS = 16;

public final int COL_ID = 0;
public final int COL_ABBREV = 1;
public final int COL_NAME = 2;
public final int COL_DATA_SOURCE = 3;
public final int COL_DATA_TYPE = 4;
public final int COL_TIME_STEP = 5;
public final int COL_UNITS = 6;
public final int COL_START = 7;
public final int COL_END = 8;
public final int COL_MEAS_COUNT = 9;
public final int COL_DIV = 10;
public final int COL_DIST = 11;
public final int COL_COUNTY = 12;
public final int COL_STATE = 13;
public final int COL_HUC = 14;
public final int COL_INPUT_TYPE = 15;

private final int __RECORD_TYPE_UNKNOWN = 0;	// Used with __record_type
private final int __RECORD_TYPE_STATIONS = 1;
private final int __RECORD_TYPE_STRUCTURES = 2;
private final int __RECORD_TYPE_WELL = 3;
//private final int __RECORD_TYPE_WIS = 4;	// TODO SAM REVISIT NOT CURRENTLY USED

private int __record_type = __RECORD_TYPE_UNKNOWN;	// Type of records being listed, for use with getValueAt().

private int __wdid_length = 7; // The length to use when formatting WDIDs in IDs.

/**
Input type for time series identifier (default to "HydroBase" but can be set to allow class to be used
with other State-related data, such as ColoradoWaterSMS).
*/
private String __inputType = "HydroBase";

/**
Constructor.  This builds the model for displaying the given HydroBase time series data.
The input type defaults to "HydroBase".
@param worksheet the JWorksheet that displays the data from the table model.
@param wdid_length Total length to use when formatting WDIDs.
@param data the Vector of HydroBase_StationGeolocMeasType or HydroBase_StructureGeolocStructMeasType
that will be displayed in the table (null is allowed - see setData()).
@inputName input name for time series (default if not specified is "HydroBase").  Use this, for example,
when using the class to display data from the ColoradoWaterSMS database.
@throws Exception if an invalid results passed in.
*/
public TSTool_HydroBase_TableModel ( JWorksheet worksheet, int wdid_length, List data )
throws Exception
{
    this ( worksheet, wdid_length, data, null );
}

/**
Constructor.  This builds the model for displaying the given HydroBase time series data.
@param worksheet the JWorksheet that displays the data from the table model.
@param wdid_length Total length to use when formatting WDIDs.
@param data the Vector of HydroBase_StationGeolocMeasType or HydroBase_StructureGeolocStructMeasType
that will be displayed in the table (null is allowed - see setData()).
@inputType input type for time series (default if null or blank is "HydroBase").  Use this, for example,
when using the class to display data from the ColoradoWaterSMS database.
@throws Exception if an invalid results passed in.
*/
public TSTool_HydroBase_TableModel ( JWorksheet worksheet, int wdid_length, List data, String inputType )
throws Exception
{	__wdid_length = wdid_length;
	if ( data == null ) {
		_rows = 0;
	}
	else {
	    _rows = data.size();
		// Figure out what types of data are listed...
		if ( _rows > 0 ) {
			Object o = (Object)data.get(0);
			if ( o instanceof HydroBase_StationGeolocMeasType ) {
				__record_type = __RECORD_TYPE_STATIONS;
			}
			else if ( o instanceof HydroBase_StructureGeolocStructMeasType ) {
				__record_type = __RECORD_TYPE_STRUCTURES;
				// Hide the abbreviation...
				// FIXME - Tom was working on this - currently it does not work here - is in TSTool_JFrame(?)
				//worksheet.removeColumn ( COL_ABBREV );
			}
			else if (o instanceof HydroBase_GroundWaterWellsView) {
			    __record_type = __RECORD_TYPE_WELL;
			}
		}
	}
	_data = data;
	if ( (inputType != null) && !inputType.equals("") ) {
	    __inputType = inputType;
	}
}

/**
From AbstractTableModel.  Returns the class of the data stored in a given column.
@param columnIndex the column for which to return the data class.
*/
public Class getColumnClass (int columnIndex) {
	switch (columnIndex) {
		// FIXME - can't seem to handle missing...
		//case COL_START:		return Integer.class;
		//case COL_END:			return Integer.class;
		//case COL_DIV:			return Integer.class;
		//case COL_DIST:		return Integer.class;
		default:			return String.class;
	}
}

/**
From AbstractTableMode.  Returns the number of columns of data.
@return the number of columns of data.
*/
public int getColumnCount() {
	return __COLUMNS;
}

/**
From AbstractTableMode.  Returns the name of the column at the given position.
@return the name of the column at the given position.
*/
public String getColumnName(int columnIndex) {
	switch (columnIndex) {
		case COL_ID:			return "ID";
		case COL_ABBREV:		return "CO Abbrev.";
		case COL_NAME:			return "Name/Description";
		case COL_DATA_SOURCE:		return "Data Source";
		case COL_DATA_TYPE:		return "Data Type";
		case COL_TIME_STEP:		return "Time Step";
		case COL_UNITS:			return "Units";
		case COL_START:			return "Start";
		case COL_END:			return "End";
		case COL_MEAS_COUNT:		return "Meas. Count";
		case COL_DIV:			return "Div.";
		case COL_DIST:			return "Dist.";
		case COL_COUNTY:		return "County";
		case COL_STATE:			return "State";
		case COL_HUC:			return "HUC";
		case COL_INPUT_TYPE:		return "Input Type";
		default:			return "";
	}
}

/**
Returns the format to display the specified column.
@param column column for which to return the format.
@return the format (as used by StringUtil.formatString()).
*/
public String getFormat ( int column ) {
	switch (column) {
		default:  return "%s"; // All are strings.
	}
}

/**
From AbstractTableMode.  Returns the number of rows of data in the table.
*/
public int getRowCount() {
	return _rows;
}

/**
From AbstractTableModel.  Returns the data that should be placed in the JTable at the given row and column.
@param row the row for which to return data.
@param col the column for which to return data.
@return the data that should be placed in the JTable at the given row and column.
*/
public Object getValueAt(int row, int col)
{	// If sorted, get the position in the data from the displayed row.
	if (_sortOrder != null) {
		row = _sortOrder[row];
	}

	int i;	// Use for integer data.

	if ( __record_type == __RECORD_TYPE_STATIONS ) {
		HydroBase_StationGeolocMeasType mt = (HydroBase_StationGeolocMeasType)_data.get(row);
		switch (col) {
			// case 0 handled above.
			case COL_ID:		return mt.getStation_id();
			case COL_ABBREV:	return mt.getAbbrev();
			case COL_NAME: 		return mt.getStation_name();
			case COL_DATA_SOURCE:	// Station also has source but want the meas_type source.
						return mt.getData_source();
			case COL_DATA_TYPE:	// TSTool translates to values from the TSTool interface...
						return mt.getMeas_type();
			case COL_TIME_STEP:	// TSTool translates HydroBase values to nicer values...
						return mt.getTime_step();
			case COL_UNITS: // The units are not in HydroBase.meas_type but are set by TSTool...
						return mt.getData_units();
			case COL_START:		//return new Integer(mt.getStart_year() );
						i = mt.getStart_year();
						if ( DMIUtil.isMissing(i) ) {
							return "";
						}
						else {
						    return "" + i;
						}
			case COL_END: //return new Integer (mt.getEnd_year() );
						i = mt.getEnd_year();
						if ( DMIUtil.isMissing(i) ) {
							return "";
						}
						else {
						    return "" + i;
						}
			case COL_MEAS_COUNT:
			            i = mt.getMeas_count();
						if ( DMIUtil.isMissing(i) ) {
							return "";
						}
						else {
						    return "" + i;
						}
			case COL_DIV: //return new Integer ( mt.getDiv() );
						i = mt.getDiv();
						if ( DMIUtil.isMissing(i) ) {
							return "";
						}
						else {
						    return "" + i;
						}
			case COL_DIST: //return new Integer ( mt.getWD() );
						i = mt.getWD();
						if ( DMIUtil.isMissing(i) ) {
							return "";
						}
						else {
						    return "" + i;
						}
			case COL_COUNTY:	return mt.getCounty();
			case COL_STATE:		return mt.getST();
			case COL_HUC:		return mt.getHUC();
			case COL_INPUT_TYPE:	return __inputType;
			default:		return "";
		}
	}
	else if ( __record_type == __RECORD_TYPE_STRUCTURES ) {
		HydroBase_StructureGeolocStructMeasType mt = (HydroBase_StructureGeolocStructMeasType)_data.get(row);
		switch (col) {
			// case 0 handled above.
			case COL_ID:
			            if ( mt.getCommon_id().length() > 0 ) {
							// Well with a different identifier to display.
							return
							mt.getCommon_id();
						}
						else {
						    // A structure other than wells...
							return
							HydroBase_WaterDistrict.formWDID (__wdid_length, mt.getWD(), mt.getID() );
						}
			case COL_NAME: 		return mt.getStr_name();
			case COL_DATA_SOURCE:	return mt.getData_source();
			case COL_DATA_TYPE:	// TSTool translates to values from the TSTool interface...
						return mt.getMeas_type();
			case COL_TIME_STEP:	// TSTool translates HydroBase values to nicer values...
						return mt.getTime_step();
			case COL_UNITS:		// The units are not in HydroBase.meas_type but are set by TSTool...
						return mt.getData_units();
			case COL_START:		//return new Integer(mt.getStart_year() );
						i = mt.getStart_year();
						if ( DMIUtil.isMissing(i) ) {
							return "";
						}
						else {
						    return "" + i;
						}
			case COL_END: //return new Integer ( mt.getEnd_year() );
						i = mt.getEnd_year();
						if ( DMIUtil.isMissing(i) ) {
							return "";
						}
						else {
						    return "" + i;
						}
			case COL_MEAS_COUNT:	i = mt.getMeas_count();
						if ( DMIUtil.isMissing(i) ) {
							return "";
						}
						else {
						    return "" + i;
						}
			case COL_DIV: //return new Integer ( mt.getDiv() );
						i = mt.getDiv();
						if ( DMIUtil.isMissing(i) ) {
							return "";
						}
						else {
						    return "" + i;
						}
			case COL_DIST: //return new Integer ( mt.getWD() );
						i = mt.getWD();
						if ( DMIUtil.isMissing(i) ) {
							return "";
						}
						else {
						    return "" + i;
						}
			case COL_COUNTY:	return mt.getCounty();
			case COL_STATE:		return mt.getST();
			case COL_HUC:		return mt.getHUC();
			case COL_INPUT_TYPE:	return __inputType;
			default:		return "";
		}
	}
	// XJTSX
	else if ( __record_type == __RECORD_TYPE_WELL) {
		HydroBase_GroundWaterWellsView wv = (HydroBase_GroundWaterWellsView) _data.get(row);

		switch (col) {
			// case 0 handled above.
			case COL_ID:		
						if ( wv.getIdentifier().length() > 0 ) {
							// Well with a different identifier to display.
							return
							wv.getIdentifier();
						}
						else {
						    // A structure other than wells...
							return HydroBase_WaterDistrict.formWDID (__wdid_length, wv.getWD(), wv.getID() );
						}
			case COL_NAME: 		return wv.getWell_name();
			case COL_DATA_SOURCE:	return wv.getData_source();
			case COL_DATA_TYPE:	// TSTool translates to values from the TSTool interface...
						return "WellLevel";
			case COL_TIME_STEP:	// TSTool translates HydroBase values to nicer values...
						return wv.getTime_step();
			case COL_UNITS: // The units are not in HydroBase.meas_type but are set by TSTool...
						return wv.getData_units();
			case COL_START: //return new Integer(wv.getStart_year() );
						i = wv.getStart_year();
						if ( DMIUtil.isMissing(i) ) {
							return "";
						}
						else {
						    return "" + i;
						}
			case COL_END: //return new Integer (wv.getEnd_year() );
						i = wv.getEnd_year();
						if ( DMIUtil.isMissing(i) ) {
							return "";
						}
						else {
						    return "" + i;
						}
			case COL_MEAS_COUNT:	i = wv.getMeas_count();
						if ( DMIUtil.isMissing(i) ) {
							return "";
						}
						else {
						    return "" + i;
						}
			case COL_DIV: //return new Integer ( wv.getDiv() );
						i = wv.getDiv();
						if ( DMIUtil.isMissing(i) ) {
							return "";
						}
						else {
						    return "" + i;
						}
			case COL_DIST: //return new Integer ( wv.getWD() );
						i = wv.getWD();
						if ( DMIUtil.isMissing(i) ) {
							return "";
						}
						else {
						    return "" + i;
						}
			case COL_COUNTY:	return wv.getCounty();
			case COL_STATE:		return wv.getST();
			case COL_HUC:		return wv.getHUC();
			case COL_INPUT_TYPE: return __inputType;
			default:		return "";
		}
	}
	else {
	    return "";
	}
}

/**
Returns an array containing the column widths (in number of characters).
@return an integer array containing the widths for each field.
*/
public int[] getColumnWidths() {
	int[] widths = new int[__COLUMNS];
	widths[COL_ID] = 12;
	widths[COL_ABBREV] = 7;
	widths[COL_NAME] = 20;
	widths[COL_DATA_SOURCE] = 10;
	widths[COL_DATA_TYPE] = 15;
	widths[COL_TIME_STEP] = 8;
	widths[COL_UNITS] = 8;
	widths[COL_START] = 10;
	widths[COL_END] = 10;
	widths[COL_MEAS_COUNT] = 8;
	widths[COL_DIV] = 5;
	widths[COL_DIST] = 5;
	widths[COL_COUNTY] = 8;
	widths[COL_STATE] = 3;
	widths[COL_HUC] = 8;
	widths[COL_INPUT_TYPE] = 12;
	return widths;
}

/**
Set the input type (default is "HydroBase" but need to change when the table model is used for
multiple purposes.
*/
public void setInputType ( String inputType )
{
    __inputType = inputType;
}

/**
Set the width of WDIDs, which controls formatting of the ID column for structures.
@param wdid_length WDID length for formatting the ID.
*/
public void setWDIDLength ( int wdid_length )
{	__wdid_length = wdid_length;
}

}