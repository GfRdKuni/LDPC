#====================================================================
# Project 		: Design Compiler script for FPGA Software Group
# File Name 	: Run_dc.tcl 
# Author	 		: 310 laboratory
# Function		: DC scripts
#====================================================================

set SRC_HOME			"/home/allenwalker/project/lab2"
set LIB_HOME			"/home/allenwalker/project/lib"
set LIBRARY_NAME	"fde_dc"
set FILE_LIST			"LDPC_top LDPC_encoder Accumulator Crossbar DFF Output_Buffer Processing_Unit ROM Serdes Sys_Cnt"
set RESULT_HOME		"/home/allenwalker/project/lab2"

#set WIRELOAD_NAME "ForQA"

#===================================================================
# Library Define
#===================================================================

set search_path " . \
								$LIB_HOME \
								$SRC_HOME"
								
set target_library " $LIB_HOME/$LIBRARY_NAME.db"

set link_library " * $LIB_HOME/$LIBRARY_NAME.db"

#===================================================================
# Source file definition
#===================================================================

set DesignName LDPC_top

#===================================================================
# Read source file
#===================================================================
define_design_lib WORK -path "work"

foreach src $FILE_LIST {
	analyze -format verilog -lib WORK $SRC_HOME/$src.v
	elaborate $src -arch "verilog" -lib WORK -update
}

current_design $DesignName
uniquify -dont_skip_empty_designs
current_design $DesignName
link

#==================================================================
# Set Compile Option
#==================================================================


ungroup -flatten -all
compile -map_effort medium -ungroup_all
ungroup -flatten -all

#==================================================================
# Compile
#==================================================================

compile_ultra -inc

#=================================================================
# Save Database
#=================================================================

write -f verilog -hier -output $RESULT_HOME/${DesignName}_gate.v