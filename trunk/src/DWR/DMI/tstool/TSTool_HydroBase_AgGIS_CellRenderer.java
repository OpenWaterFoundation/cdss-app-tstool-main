// ----------------------------------------------------------------------------
// TSTool_HydroBase_AgGIS_CellRenderer - class to render cells for HydroBase
//					agricultural TS - GIS based irrigated
//					acreage
// ----------------------------------------------------------------------------
// Copyright:   See the COPYRIGHT file
// ----------------------------------------------------------------------------
// History:
//
// 2004-02-08	Steven A. Malers, RTi	Initial version - copy and modify
//					TSTool_HydroBase_Ag_CellRenderer.
// 2007-02-26	SAM, RTi		Clean up code based on Eclipse feedback.
// ----------------------------------------------------------------------------

package DWR.DMI.tstool;

import RTi.Util.GUI.JWorksheet_DefaultTableCellRenderer;

/**
This class is used to render cells for TSTool_HydroBase_AgGIS_TableModel data,
for irrig_summary_ts.
*/
public class TSTool_HydroBase_AgGIS_CellRenderer
extends JWorksheet_DefaultTableCellRenderer {

TSTool_HydroBase_AgGIS_TableModel __table_model = null;	// Table model to
							// render

/**
Constructor.
@param table_model The TSTool_HydroBase_AgGIS_TableModel to render.
*/
public TSTool_HydroBase_AgGIS_CellRenderer (
	TSTool_HydroBase_AgGIS_TableModel table_model )
{	__table_model = table_model;
}

/**
Returns the format for a given column.
@param column the colum for which to return the format.
@return the column format as used by StringUtil.formatString().
*/
public String getFormat(int column) {
	return __table_model.getFormat(column);	
}

/**
Returns the widths of the columns in the table.
@return an integer array of the widths of the columns in the table.
*/
public int[] getColumnWidths() {
	return __table_model.getColumnWidths();
}

}
