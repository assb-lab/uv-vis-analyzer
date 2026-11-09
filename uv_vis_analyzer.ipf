#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

static StrConstant ksUVVisAnalyzerVersion = "0.1.0"

Menu "Macros"
	"🔦 UV-VIS Analyzer",  init_uv_vis_analyzer()

End

function init_uv_vis_analyzer()
	
	Newdatafolder/O/S root:Macro_UV_VIS
	variable/G eg_bandgap=0
	variable/G eg_direct=0
	variable/G eg_indirect=0
	Execute("uv_vis_analyzer_panel()")
	string panel_title = "UV-VIS-Analyzer v"+ksUVVisAnalyzerVersion
	DoWindow/T uv_vis_analyzer_panel, panel_title
	setdataFolder root:
end


Window uv_vis_analyzer_panel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(1013,232,1709,597) as "UV-VIS-Analyzer"
	SetDrawLayer UserBack
	SetDrawEnv fsize= 16
	DrawText 15,25,"\\f00Analyze UV-VIS spectra "
	SetDrawEnv linethick= 2,arrow= 1,arrowfat= 0.8
	DrawLine 117,172,117,187
	SetDrawEnv linethick= 2,arrow= 1,arrowfat= 0.8
	DrawLine 117,230,117,245
	SetDrawEnv fsize= 16
	DrawText 15,101,"Band Gap"
	SetDrawEnv linethick= 2,arrow= 1,arrowfat= 0.8
	DrawLine 347,172,347,187
	SetDrawEnv linethick= 2,arrow= 1,arrowfat= 0.8
	DrawLine 347,230,347,245
	SetDrawEnv fsize= 16
	DrawText 245,101,"Direct Band Gap"
	SetDrawEnv linethick= 2,arrow= 1,arrowfat= 0.8
	DrawLine 577,172,577,187
	SetDrawEnv linethick= 2,arrow= 1,arrowfat= 0.8
	DrawLine 577,230,577,245
	SetDrawEnv fsize= 16
	DrawText 475,101,"Indirect Band Gap"
	DrawText 18,126,"Onset of absorption"
	DrawText 245,126,"Onset of absorption"
	DrawText 475,126,"Onset of absorption"
	DrawText 18,187,"Background"
	DrawText 247,187,"Background"
	DrawText 477,187,"Background"
	Button button_uvvis_load,pos={16.00,39.00},size={660.00,32.00},proc=ButtonProc_uvvis_load,title="Load UV-VIS spectra (*.txt)"
	Button button_uvvis_load,fSize=16,fColor=(65535,65535,65535)
	Button button_uvvis_bandgap_linear,pos={16.00,129.00},size={200.00,41.00},proc=ButtonProc_uvvis_bandgap_linear,title="Cursor(A, B)"
	Button button_uvvis_bandgap_linear,fSize=15,fColor=(65535,65535,65535)
	Button button_uvvis_bandgap_bg,pos={118.00,190.00},size={98.00,40.00},proc=ButtonProc_uvvis_bandgap_bg,title="Cursor(C, D)"
	Button button_uvvis_bandgap_bg,fSize=15
	Button button_uvvis_calc_eg_bandgap,pos={16.00,250.00},size={200.00,40.00},proc=ButtonProc_uvvis_calc_eg_bandgap,title="Calculate \\f02E\\f00\\Bg\\M"
	Button button_uvvis_calc_eg_bandgap,fSize=16
	SetVariable setvar_uvvis_eg_bandgap,pos={19.00,303.00},size={200.00,26.00},title="\\f02E\\f00\\Bg \\M(eV):"
	SetVariable setvar_uvvis_eg_bandgap,fSize=16
	SetVariable setvar_uvvis_eg_bandgap,limits={-inf,inf,0},value= root:Macro_UV_VIS:eg_bandgap
	Button button_uvvis_direct_linear,pos={246.00,129.00},size={200.00,41.00},proc=ButtonProc_uvvis_direct_linear,title="Cursor(A, B)"
	Button button_uvvis_direct_linear,fSize=15,fColor=(65535,65535,65535)
	Button button_uvvis_direct_bg,pos={348.00,190.00},size={98.00,40.00},proc=ButtonProc_uvvis_direct_bg,title="Cursor(C, D)"
	Button button_uvvis_direct_bg,fSize=15
	Button button_uvvis_calc_eg_direct,pos={246.00,250.00},size={200.00,40.00},proc=ButtonProc_uvvis_calc_eg_direct,title="Calculate \\f02E\\f00\\Bg,direct\\M"
	Button button_uvvis_calc_eg_direct,fSize=16
	SetVariable setvar_uvvis_eg_direct,pos={249.00,303.00},size={200.00,26.00},title="\\f02E\\f00\\Bg,direct \\M(eV):"
	SetVariable setvar_uvvis_eg_direct,fSize=16
	SetVariable setvar_uvvis_eg_direct,limits={-inf,inf,0},value= root:Macro_UV_VIS:eg_direct
	Button button_uvvis_indirect_linear,pos={476.00,130.00},size={200.00,40.00},proc=ButtonProc_uvvis_indirect_linear,title="Cursor(A, B)"
	Button button_uvvis_indirect_linear,fSize=15,fColor=(65535,65535,65535)
	Button button_uvvis_indirect_bg,pos={578.00,190.00},size={98.00,40.00},proc=ButtonProc_uvvis_indirect_bg,title="Cursor(C, D)"
	Button button_uvvis_indirect_bg,fSize=15
	Button button_uvvis_calc_eg_indirect,pos={476.00,249.00},size={200.00,40.00},proc=ButtonProc_uvvis_calc_eg_indirect,title="Calculate \\f02E\\f00\\Bg,indirect\\M"
	Button button_uvvis_calc_eg_indirect,fSize=16
	SetVariable setvar_uvvis_eg_indirect,pos={479.00,302.00},size={200.00,26.00},title="\\f02E\\f00\\Bg,indirect \\M(eV):"
	SetVariable setvar_uvvis_eg_indirect,fSize=16
	SetVariable setvar_uvvis_eg_indirect,limits={-inf,inf,0},value= root:Macro_UV_VIS:eg_indirect
	Button button_uvvis_bandgap_bg_zero,pos={16.00,190.00},size={98.00,40.00},proc=ButtonProc_uvvis_bandgap_bg_zero,title="Zero Line"
	Button button_uvvis_bandgap_bg_zero,fSize=15
	Button button_uvvis_direct_bg1,pos={246.00,190.00},size={98.00,40.00},proc=ButtonProc_uvvis_direct_bg_zero,title="Zero Line"
	Button button_uvvis_direct_bg1,fSize=15
	Button button_uvvis_indirect_bg_zero,pos={476.00,190.00},size={98.00,40.00},proc=ButtonProc_uvvis_indirect_bg_zero,title="Zero Line"
	Button button_uvvis_indirect_bg_zero,fSize=15
EndMacro

Function ButtonProc_uvvis_load(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			uv_vis_txt_load_and_plot()
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_uvvis_bandgap_linear(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			fit_uvvis_spectra_base(NameOfWave(WaveRefIndexed("",0,1))+"_linear_fit","coef_bandgap_linear","A;B",0)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_uvvis_bandgap_bg(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			fit_uvvis_spectra_base(NameOfWave(WaveRefIndexed("",0,1))+"_bg_fit","coef_bandgap_bg","C;D",0)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_uvvis_bandgap_bg_zero(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			fit_uvvis_spectra_base(NameOfWave(WaveRefIndexed("",0,1))+"_bg_fit","coef_bandgap_bg","C;D",1)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_uvvis_calc_eg_bandgap(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			calc_bandgap(3)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_uvvis_direct_linear(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			fit_uvvis_spectra_base(NameOfWave(WaveRefIndexed("",0,1))+"_linear_fit","coef_direct_linear","A;B",0)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_uvvis_indirect_linear(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			fit_uvvis_spectra_base(NameOfWave(WaveRefIndexed("",0,1))+"_linear_fit","coef_indirect_linear","A;B",0)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_uvvis_direct_bg(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			fit_uvvis_spectra_base(NameOfWave(WaveRefIndexed("",0,1))+"_bg_fit","coef_direct_bg","C;D",0)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End


Function ButtonProc_uvvis_direct_bg_zero(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			fit_uvvis_spectra_base(NameOfWave(WaveRefIndexed("",0,1))+"_bg_fit","coef_direct_bg","C;D",1)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End



Function ButtonProc_uvvis_calc_eg_direct(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			calc_bandgap(1)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_uvvis_indirect_bg(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			fit_uvvis_spectra_base(NameOfWave(WaveRefIndexed("",0,1))+"_bg_fit","coef_indirect_bg","C;D",0)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_uvvis_indirect_bg_zero(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			fit_uvvis_spectra_base(NameOfWave(WaveRefIndexed("",0,1))+"_bg_fit","coef_indirect_bg","C;D",1)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_uvvis_calc_eg_indirect(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			calc_bandgap(2)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End


	
function uv_vis_txt_load_and_plot()
	
	string filename
	wave w_wavelength
	wave w_reflectivity
	
	[filename, w_wavelength,w_reflectivity] = uv_vis_txt_load()
	
	wave w_photon_energy = create_wave_of_photon_energy_from(filename,w_wavelength)
	wave w_km_func = create_wave_of_kubelka_munk_function_from(filename,w_reflectivity)

	wave w_tauc_direct = create_wave_of_tauc_plot_direct_from(filename,w_km_func,w_photon_energy)
	wave w_tauc_indirect = create_wave_of_tauc_plot_indirect_from(filename,w_km_func,w_photon_energy)
	
	print "output "+filename
	
	plot_kubelka_munk_vs_photon_energy(w_km_func,w_photon_energy)
	put_cursor_for_uv_vis_fitting()
	plot_kubelka_munk_vs_wavelength(w_km_func,w_wavelength)
	put_cursor_for_uv_vis_fitting()
	plot_tauc_plot_direct(w_tauc_direct,w_photon_energy)
	put_cursor_for_uv_vis_fitting()
	plot_tauc_plot_indirect(w_tauc_indirect,w_photon_energy)
	put_cursor_for_uv_vis_fitting()
	
	setdatafolder root:
end

function[string filename,wave w_wavelength,wave w_reflectivity] uv_vis_txt_load()
	Variable a 
	String fileFilters = "txt file :.txt;"
  	OPEN/D/R/F=fileFilters/Z=2 a
   
   filename = S_filename
  	string filepath = S_filename
 
 	if(cmpstr(filename,"")==0) 
		setdatafolder root:
		abort
	Endif
	
	validate_filename(filename)
	string columnInfoStr = "N="+filename+";"
	
	NewdataFolder/O/S $(filename)	
	LoadWave/A=$(filename+"_")/Q/J/K=1/V={",","",0,0}/L={0,2,0,0,2} filepath
	
	rename $(filename+"_0"), $(filename+"_wavelength")
	wave w_wavelength = $(filename+"_wavelength")
	
	rename $(filename+"_1"), $(filename+"_reflectivity")
	wave w_reflectivity = $(filename+"_reflectivity")
	
	return [filename,w_wavelength,w_reflectivity]

end

function/wave create_wave_of_kubelka_munk_function_from(string filename, wave w_reflectivity)
	
	string error_message=""
	int err
	[error_message,err] = check_filename_and_input_wave(filename,w_reflectivity)
	
	if(err !=0)
		setdatafolder root:
		abort error_message
	endif
	
	duplicate w_reflectivity, $(filename+"_kubelka_munk")
	wave w_km_func = $(filename+"_kubelka_munk")
	w_km_func = (1-w_reflectivity/100)^2/(2*w_reflectivity/100)
	return w_km_func
end

function/Wave create_wave_of_photon_energy_from(string filename, wave w_wavelength)
	
	variable coef = 1239.84
	
	string error_message=""
	int err
	[error_message,err] = check_filename_and_input_wave(filename,w_wavelength)
	
	if(err !=0)
		setdatafolder root:
		abort error_message
	endif
	
	duplicate w_wavelength, $(filename+"_photon_energy_eV")
	wave w_photon_energy = $(filename+"_photon_energy_eV")
	w_photon_energy = coef / w_wavelength
	return w_photon_energy
	
end

function/Wave create_wave_of_tauc_plot_direct_from(string filename, wave w_km_func,wave w_photon_energy)
	
	variable coef_n = 2
	wave 	w_tauc_direct = create_wave_of_tauc_plot_from(coef_n,"_tauc_direct",filename,w_km_func,w_photon_energy)
	return w_tauc_direct
	
end

function/Wave create_wave_of_tauc_plot_indirect_from(string filename, wave w_km_func,wave w_photon_energy)
	
	variable coef_n = 1/2
	wave 	w_tauc_direct = create_wave_of_tauc_plot_from(coef_n,"_tauc_indirect",filename,w_km_func,w_photon_energy)
	return w_tauc_direct
	
end


function/Wave create_wave_of_tauc_plot_from(variable coef_n,string surfix, string filename, wave w_km_func,wave w_photon_energy)
	
	string error_message=""
	int err
	[error_message,err] = check_filename_and_input_wave(filename,w_km_func)
	
	if(err !=0)
		setdatafolder root:
		abort error_message
	endif
	
	duplicate w_km_func, $(filename+surfix)
	wave w_tauc_direct = $(filename+surfix)
	w_tauc_direct = (w_km_func * w_photon_energy)^(coef_n)
	return w_tauc_direct
	
end


function[string message, int err] check_filename_and_input_wave(string filename, wave wave_input)
	int len =strlen(filename)
	
	if( len == 0 || numtype(len) !=0)
		message = "filename is valid"
		return [message,1]
	endif

	if(waveExists(wave_input) !=1)
		message = "wave_input does not exists"
		return [message,1]
	endif	
	
	return ["",0]
end



function validate_filename(string &filename)
  	filename = Parsefilepath(0, filename , ":",  1, 0 )
  	variable num_of_period =count_word(filename,".")
	
  	filename = replaceString(".", filename, "_", 1, num_of_period-1)
  	filename = replaceString("-", filename, "", 1, inf)
  	filename = replaceString(" ", filename, "_", 1, inf)
  	filename = replaceString("(", filename, "_", 1, inf)
  	filename = replaceString(")", filename, "_", 1, inf)
  	filename = replaceString("-", filename, "_", 1, inf)
  	filename = Parsefilepath(0, filename , ".",  0, 0 )
  	filename = replaceString("__", filename, "_", 1, inf)
  	if (GrepString(filename[0],"[0-9]"))
		filename ="a"+filename
	Endif

end


function plot_tauc_plot_direct(wave w_int,wave w_photon)
	Display /W=(2,743,438,1309) w_int vs w_photon as "tauc_plot_direct"
	set_style_for_tauc_plot_base()
	set_style_for_tauc_plot_direct()
end

function plot_tauc_plot_indirect(wave w_int,wave w_photon)
	Display /W=(439,743,875,1309) w_int vs w_photon as  "tauc_plot_indirect"
	set_style_for_tauc_plot_base()
	set_style_for_tauc_plot_indirect()
end

function plot_kubelka_munk_vs_wavelength(wave w_int,wave w_wavelength)
	Display /W=(439,59,875,625) w_int vs w_wavelength as "kubelka_munk_vs_wavelength"
	set_style_for_kubelka_munk_base()
	set_style_for_kubelka_munk_vs_wavelength()
end

function plot_kubelka_munk_vs_photon_energy(wave w_int,wave w_photon)
	Display /W=(2,59,438,625) w_int vs w_photon as "kubelka_munk_vs_photon_energy"
	set_style_for_kubelka_munk_base()
	set_style_for_kubelka_munk_vs_photon_energy()
end


function set_style_for_tauc_plot_base()
	ModifyGraph margin(left)=34,margin(bottom)=36,margin(top)=14,margin(right)=14,expand=-2
	ModifyGraph gFont="Arial",gfSize=12,width=170.079,height=226.772
	ModifyGraph tick=2
	ModifyGraph mirror=1
	ModifyGraph font="Arial"
	ModifyGraph noLabel(left)=1
	Label bottom "Photon energy \\f02hν\\f00 / eV"
	
end



function set_style_for_tauc_plot_direct()
	Label left "\\Z14(\\f02F\\f00(\\f02R\\f00)·\\f02hν\\f00)\\S2\\M\\Z14 / a.u."
end


function set_style_for_tauc_plot_indirect()
	Label left "\\Z14(\\f02F\\f00(\\f02R\\f00)·\\f02hν\\f00)\\S1/2\\M\\Z14 / a.u."
end

function set_style_for_kubelka_munk_base()
	ModifyGraph margin(left)=34,margin(bottom)=36,margin(top)=14,margin(right)=14,expand=-2
	ModifyGraph gFont="Arial",gfSize=12,width=170.079,height=226.772
	ModifyGraph tick=2
	ModifyGraph mirror=1
	ModifyGraph font="Arial"
	ModifyGraph noLabel(left)=0
	Label left "\\Z14\\f02F\\f00(\\f02R\\f00) / a.u."
end

function set_style_for_kubelka_munk_vs_wavelength()
	ModifyGraph sep(bottom)=2
	ModifyGraph manTick(bottom)={0,200,0,0},manMinor(bottom)={1,50}
	Label bottom "\\Z14Wavelength \\f02λ\\f00 / nm"
end

function set_style_for_kubelka_munk_vs_photon_energy()
	Label bottom "Photon energy \\f02hν\\f00 / eV"
end

function put_cursor_for_uv_vis_fitting()
	showinfo/CP={0,1}
	Cursor A, $(stringfromlist(0, tracenameList("",";",1+4))),40
	Cursor B, $(stringfromlist(0, tracenameList("",";",1+4))),60
	Cursor C, $(stringfromlist(0, tracenameList("",";",1+4))),500
	Cursor D, $(stringfromlist(0, tracenameList("",";",1+4))),300
end


function fit_uvvis_spectra_base(name_savedata, name_of_coef, name_of_cursor,isZeroBgUsed)

	string name_savedata
	string name_of_coef
	string name_of_cursor //A;B or C;D
	int isZeroBgUsed //1 or 0
	
	DFREF data_folder 
	
	int err = is_name_of_cursor_valid(name_of_cursor)
	if(err != 0)
		abort "name_of_cursor is invalid"
	endif
	
	if( isZeroBgUsed != 0 && isZeroBgUsed != 1 )
		abort "isZeroBgUsed is invalid"
	endif
		
	
	string wavelist_in_current_graph = traceNameList("",";",1)
	wavelist_in_current_graph = replacestring( "'",wavelist_in_current_graph,"")
	
	data_folder= GetWavesDataFolderDFR(csrWaveRef($(StringFromList(0,name_of_cursor))))
	wave Ywave = csrWaveRef($(StringFromList(0,name_of_cursor)))
	wave Xwave =csrxWaveRef($(StringFromList(0,name_of_cursor)))
	

	Make/D/O/N=2 data_folder:$(name_of_coef)
	wave wave_coef_new = data_folder:$(name_of_coef)

	if(isZeroBgUsed ==0)
		CurveFit/W=0 line ,kwCWave=data_folder:$(name_of_coef) Ywave[pcsr($(StringFromList(0,name_of_cursor))),pcsr($(StringFromList(1,name_of_cursor)))] /X=Xwave 
	else
		wave_coef_new=0	
	endif
		
	
	
	make/O/N=2,data_folder:$(name_savedata)
	wave wave_fit_new = data_folder:$(name_savedata)
	
	calc_uvvis_fit_curve_region(wave_fit_new,wave_coef_new)
	
	if(FindListItem(name_savedata, wavelist_in_current_graph)== -1)
		appendtograph wave_fit_new
		
		strswitch(name_of_cursor)	// string switch
			case "A;B":	// execute if case matches expression
				set_style_on_uvvis_fit_curve_linear_region(name_savedata)
				break		// exit from switch
			case "C;D":	// execute if case matches expression
				set_style_on_uvvis_fit_curve_bg_region(name_savedata)
				break
			default:			// optional default expression executed
				abort "name_of_cursor is invalid."
		endswitch 
	endif
	
end

function is_name_of_cursor_valid(string name_of_cursor)
	strswitch(name_of_cursor)	// string switch
		case "A;B":	// execute if case matches expression
			
			return 0		// exit from switch
		case "C;D":	// execute if case matches expression
			return 0
		default:			// optional default expression executed
			return 1
	endswitch
end


function set_style_on_uvvis_fit_curve_linear_region(string name_of_wave)
	ModifyGraph rgb($(name_of_wave))=(1,16019,65535)
end

function set_style_on_uvvis_fit_curve_bg_region(string name_of_wave)
	ModifyGraph rgb($(name_of_wave))=(0,0,0)
	ModifyGraph lstyle($(name_of_wave))=1
end

function calc_uvvis_fit_curve_region(wave wave_fit_new, wave wave_coef_new )
	
	GetAxis/Q bottom
	variable x_graph_min=V_min, x_graph_max=V_max
	
	GetAxis/Q left
	variable y_graph_min=V_min, y_graph_max=V_max	
	
	variable y_graph_x_min_fit = wave_coef_new[0]+wave_coef_new[1]*x_graph_min
	variable y_graph_x_max_fit = wave_coef_new[0]+wave_coef_new[1]*x_graph_max
	
	variable x_graph_min_after
	variable x_graph_max_after
	variable y_graph_min_after
	variable y_graph_max_after	

	if(y_graph_x_max_fit >y_graph_x_min_fit)
		y_graph_max_after =y_graph_x_max_fit
		y_graph_min_after = y_graph_x_min_fit
	else
		y_graph_min_after =y_graph_x_max_fit
		y_graph_max_after = y_graph_x_min_fit	
	endif
	
	if(y_graph_max_after > y_graph_max ||   y_graph_min_after > y_graph_x_min_fit)
		x_graph_min_after= (y_graph_min-wave_coef_new[0])/wave_coef_new[1]
		x_graph_max_after= (y_graph_max-wave_coef_new[0])/wave_coef_new[1]
		if(x_graph_max_after < x_graph_min_after)		
			y_graph_max_after = x_graph_min_after
			x_graph_min_after = x_graph_max_after
			x_graph_max_after =  y_graph_max_after
		endif
	else 
		x_graph_min_after = x_graph_min
		x_graph_max_after = x_graph_max
	endif
	
	SetScale/P x x_graph_min_after,x_graph_max_after-x_graph_min_after,"", wave_fit_new
	wave_fit_new[0] =wave_coef_new[0]+wave_coef_new[1]*x_graph_min_after
	wave_fit_new[1] = wave_coef_new[0]+wave_coef_new[1]*x_graph_max_after
end

function ensure_linear_and_bg_fit_exist(DFREF data_folder, string y_name, string coef_linear_name, string coef_bg_name)
	wave/Z w_linear_fit = data_folder:$(y_name+"_linear_fit")
	wave/Z w_bg_fit = data_folder:$(y_name+"_bg_fit")
	wave/Z coef_linear = data_folder:$coef_linear_name
	wave/Z coef_bg = data_folder:$coef_bg_name

	if(WaveExists(w_linear_fit) != 1 || WaveExists(w_bg_fit) != 1 || WaveExists(coef_linear) != 1 || WaveExists(coef_bg) != 1)
		abort "linear_fit or bg_fit is not defined."
	endif
end

function calc_bandgap(typ)
	variable typ
	DFREF data_folder = GetWavesDataFolderDFR(WaveRefIndexed("",0,1))
	string y_name = NameOfWave(WaveRefIndexed("",0,1))

	variable eg
	string label_Eg=""
		
	switch(typ)	// numeric switch
		case 3:
			ensure_linear_and_bg_fit_exist(data_folder, y_name, "coef_bandgap_linear", "coef_bandgap_bg")
			wave coef_BG   = data_folder:$("coef_bandgap_linear")
			wave coef_linear = data_folder:$("coef_bandgap_bg")
			eg = (coef_linear[0] - coef_BG[0]) / (coef_BG[1]-coef_linear[1])

			label_Eg = num2str(eg)+" eV"
			print "Eg= "+label_Eg
			label_Eg= "\\f02E\\f00\\Bg \\M= " +label_Eg
			TextBox/C/N=label_Eg_bandgap/F=0/B=1/A=LC/Y=42.00 label_Eg

			Nvar eg_bandgap=root:Macro_UV_VIS:eg_bandgap
			eg_bandgap =eg
			break
		case 1:	// execute if case matches expression
			ensure_linear_and_bg_fit_exist(data_folder, y_name, "coef_direct_linear", "coef_direct_bg")
			wave coef_BG   = data_folder:$("coef_direct_linear")
			wave coef_linear = data_folder:$("coef_direct_bg")
			eg = (coef_linear[0] - coef_BG[0]) / (coef_BG[1]-coef_linear[1])
		
			label_Eg = num2str(eg)+" eV"
			print "Eg,direct= "+label_Eg
			label_Eg= "\\f02E\\f00\\Bg,direct \\M= " +label_Eg
			TextBox/C/N=label_Eg/F=0/B=1/A=LC/Y=42.00 label_Eg
		
			Nvar eg_direct=root:Macro_UV_VIS:eg_direct
			eg_direct =eg
			break		// exit from switch
	case 2:
			ensure_linear_and_bg_fit_exist(data_folder, y_name, "coef_indirect_linear", "coef_indirect_bg")
			wave coef_BG   = data_folder:$("coef_indirect_linear")
			wave coef_linear = data_folder:$("coef_indirect_bg")
			print(nameOfWave(coef_BG))
			print(nameOfWave(coef_linear))
			eg = (coef_linear[0] - coef_BG[0]) / (coef_BG[1]-coef_linear[1])
			label_Eg = num2str(eg)+" eV"
			print "Ecutoff= "+label_Eg
			label_Eg= "\\f02E\\f00\\Bg,indirect \\M= " +label_Eg
			TextBox/C/N=label_Eg/F=0/B=1/A=LC/Y=42.00 label_Eg
		
			Nvar eg_indirect=root:Macro_UV_VIS:eg_indirect
			eg_indirect =eg
		
		break
	default:			// optional default expression executed
		abort "type is invalid"
	
	endswitch

end

