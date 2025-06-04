`ifndef UVM_MACROS_SVH
`define UVM_MACROS_SVH

`ifdef MODEL_TECH
`ifndef QUESTA
`define QUESTA
`endif
`endif

`ifndef UVM_USE_STRING_QUEUE_STREAMING_PACK
  `define UVM_STRING_QUEUE_STREAMING_PACK(q) uvm_pkg::m_uvm_string_queue_join(q)
`endif

`ifndef QUESTA
`define uvm_typename(X) $typename(X)
`else
`define uvm_typename(X) $typename(X,39)
`endif

`ifdef INCA
  `define UVM_USE_PROCESS_CONTAINER
`endif

`define uvm_delay(TIME) #(TIME);

`ifndef UVM_VERSION_DEFINES_SVH
`define UVM_VERSION_DEFINES_SVH

`define UVM_MAJOR_REV 1

`define UVM_MINOR_REV 2

`define UVM_NAME UVM


`ifdef UVM_FIX_REV
 `define UVM_VERSION_STRING `"`UVM_NAME``-```UVM_MAJOR_REV``.```UVM_MINOR_REV`UVM_FIX_REV`"
`else
 `define UVM_VERSION_STRING `"`UVM_NAME``-```UVM_MAJOR_REV``.```UVM_MINOR_REV```"
`endif

`define UVM_MAJOR_REV_1


`define UVM_MINOR_REV_2


`define UVM_VERSION_1_2

`define UVM_MAJOR_VERSION_1_2

`define UVM_POST_VERSION_1_1

`endif 

`ifndef UVM_GLOBAL_DEFINES_SVH
`define UVM_GLOBAL_DEFINES_SVH


`ifndef UVM_MAX_STREAMBITS
 `define UVM_MAX_STREAMBITS 4096
`endif



`ifndef UVM_PACKER_MAX_BYTES
 `define UVM_PACKER_MAX_BYTES `UVM_MAX_STREAMBITS
`endif


`define UVM_DEFAULT_TIMEOUT 9200s

`endif 

`ifndef UVM_MESSAGE_DEFINES_SVH
`define UVM_MESSAGE_DEFINES_SVH

`ifndef UVM_LINE_WIDTH
  `define UVM_LINE_WIDTH 120
`endif 

`ifndef UVM_NUM_LINES
  `define UVM_NUM_LINES 120
`endif

`ifdef UVM_REPORT_DISABLE_FILE_LINE
`define UVM_REPORT_DISABLE_FILE
`define UVM_REPORT_DISABLE_LINE
`endif

`ifdef UVM_REPORT_DISABLE_FILE
`define uvm_file ""
`else
`define uvm_file `__FILE__
`endif

`ifdef UVM_REPORT_DISABLE_LINE
`define uvm_line 0
`else
`define uvm_line `__LINE__
`endif


`define uvm_info(ID, MSG, VERBOSITY) \
   begin \
     if (uvm_report_enabled(VERBOSITY,UVM_INFO,ID)) \
       uvm_report_info (ID, MSG, VERBOSITY, `uvm_file, `uvm_line, "", 1); \
   end



`define uvm_warning(ID, MSG) \
   begin \
     if (uvm_report_enabled(UVM_NONE,UVM_WARNING,ID)) \
       uvm_report_warning (ID, MSG, UVM_NONE, `uvm_file, `uvm_line, "", 1); \
   end



`define uvm_error(ID, MSG) \
   begin \
     if (uvm_report_enabled(UVM_NONE,UVM_ERROR,ID)) \
       uvm_report_error (ID, MSG, UVM_NONE, `uvm_file, `uvm_line, "", 1); \
   end



`define uvm_fatal(ID, MSG) \
   begin \
     if (uvm_report_enabled(UVM_NONE,UVM_FATAL,ID)) \
       uvm_report_fatal (ID, MSG, UVM_NONE, `uvm_file, `uvm_line, "", 1); \
   end




`define uvm_info_context(ID, MSG, VERBOSITY, RO) \
   begin \
     if (RO.uvm_report_enabled(VERBOSITY,UVM_INFO,ID)) \
       RO.uvm_report_info (ID, MSG, VERBOSITY, `uvm_file, `uvm_line, "", 1); \
   end



`define uvm_warning_context(ID, MSG, RO) \
   begin \
     if (RO.uvm_report_enabled(UVM_NONE,UVM_WARNING,ID)) \
       RO.uvm_report_warning (ID, MSG, UVM_NONE, `uvm_file, `uvm_line, "", 1); \
   end



`define uvm_error_context(ID, MSG, RO) \
   begin \
     if (RO.uvm_report_enabled(UVM_NONE,UVM_ERROR,ID)) \
       RO.uvm_report_error (ID, MSG, UVM_NONE, `uvm_file, `uvm_line, "", 1); \
   end



`define uvm_fatal_context(ID, MSG, RO) \
   begin \
     if (RO.uvm_report_enabled(UVM_NONE,UVM_FATAL,ID)) \
       RO.uvm_report_fatal (ID, MSG, UVM_NONE, `uvm_file, `uvm_line, "", 1); \
   end



`define uvm_message_begin(SEVERITY, ID, MSG, VERBOSITY, FILE, LINE, RM) \
   begin \
     if (uvm_report_enabled(VERBOSITY,SEVERITY,ID)) begin \
       uvm_report_message __uvm_msg; \
       if (RM == null) RM = uvm_report_message::new_report_message(); \
       __uvm_msg = RM; \
       __uvm_msg.set_report_message(SEVERITY, ID, MSG, VERBOSITY, FILE, LINE, "");



`define uvm_message_end \
       uvm_process_report_message(__uvm_msg); \
     end \
   end


`define uvm_message_context_begin(SEVERITY, ID, MSG, VERBOSITY, FILE, LINE, RO, RM) \
   begin \
     uvm_report_object __report_object; \
     __report_object = RO; \
     if (__report_object.uvm_report_enabled(VERBOSITY,SEVERITY,ID)) begin \
       uvm_report_message __uvm_msg; \
       if (RM == null) RM = uvm_report_message::new_report_message(); \
       __uvm_msg = RM; \
       __uvm_msg.set_report_message(SEVERITY, ID, MSG, VERBOSITY, FILE, LINE, "");



`define uvm_message_context_end \
       __report_object.uvm_process_report_message(__uvm_msg); \
     end \
   end


`define uvm_info_begin(ID, MSG, VERBOSITY, RM = __uvm_msg) \
   `uvm_message_begin(UVM_INFO, ID, MSG, VERBOSITY, `uvm_file, `uvm_line, RM)

`define uvm_info_end \
   `uvm_message_end


`define uvm_warning_begin(ID, MSG, RM = __uvm_msg) \
   `uvm_message_begin(UVM_WARNING, ID, MSG, UVM_NONE, `uvm_file, `uvm_line, RM)

`define uvm_warning_end \
   `uvm_message_end


`define uvm_error_begin(ID, MSG, RM = __uvm_msg) \
   `uvm_message_begin(UVM_ERROR, ID, MSG, UVM_NONE, `uvm_file, `uvm_line, RM)


`define uvm_error_end \
   `uvm_message_end


`define uvm_fatal_begin(ID, MSG, RM = __uvm_msg) \
   `uvm_message_begin(UVM_FATAL, ID, MSG, UVM_NONE, `uvm_file, `uvm_line, RM)

`define uvm_fatal_end \
   `uvm_message_end


`define uvm_info_context_begin(ID, MSG, VERBOSITY, RO, RM = __uvm_msg) \
   `uvm_message_context_begin(UVM_INFO, ID, MSG, VERBOSITY, `uvm_file, `uvm_line, RO, RM)


`define uvm_info_context_end \
   `uvm_message_context_end

 
`define uvm_warning_context_begin(ID, MSG, RO, RM = __uvm_msg) \
   `uvm_message_context_begin(UVM_WARNING, ID, MSG, UVM_NONE, `uvm_file, `uvm_line, RO, RM)



`define uvm_warning_context_end \
   `uvm_message_context_end


`define uvm_error_context_begin(ID, MSG, RO, RM = __uvm_msg) \
   `uvm_message_context_begin(UVM_ERROR, ID, MSG, UVM_NONE, `uvm_file, `uvm_line, RO, RM)

`define uvm_error_context_end \
   `uvm_message_context_end


`define uvm_fatal_context_begin(ID, MSG, RO, RM = __uvm_msg) \
   `uvm_message_context_begin(UVM_FATAL, ID, MSG, UVM_NONE, `uvm_file, `uvm_line, RO, RM)

`define uvm_fatal_context_end \
   `uvm_message_context_end


`define uvm_message_add_tag(NAME, VALUE, ACTION=(UVM_LOG|UVM_RM_RECORD)) \
    __uvm_msg.add_string(NAME, VALUE, ACTION);

`define uvm_message_add_int(VAR, RADIX, LABEL="", ACTION=(UVM_LOG|UVM_RM_RECORD)) \
    if (LABEL == "") \
      __uvm_msg.add_int(`"VAR`", VAR, $bits(VAR), RADIX, ACTION); \
    else \
      __uvm_msg.add_int(LABEL, VAR, $bits(VAR), RADIX, ACTION);


`define uvm_message_add_string(VAR, LABEL="", ACTION=(UVM_LOG|UVM_RM_RECORD)) \
    if (LABEL == "") \
      __uvm_msg.add_string(`"VAR`", VAR, ACTION); \
    else \
      __uvm_msg.add_string(LABEL, VAR, ACTION);

`define uvm_message_add_object(VAR, LABEL="", ACTION=(UVM_LOG|UVM_RM_RECORD)) \
    if (LABEL == "") \
      __uvm_msg.add_object(`"VAR`", VAR, ACTION); \
    else \
      __uvm_msg.add_object(LABEL, VAR, ACTION);


`endif 


`ifndef UVM_PHASE_DEFINES_SVH
`define UVM_PHASE_DEFINES_SVH


`define m_uvm_task_phase(PHASE,COMP,PREFIX) \
        class PREFIX``PHASE``_phase extends uvm_task_phase; \
          virtual task exec_task(uvm_component comp, uvm_phase phase); \
            COMP comp_; \
            if ($cast(comp_,comp)) \
              comp_.``PHASE``_phase(phase); \
          endtask \
          local static PREFIX``PHASE``_phase m_inst; \
          static const string type_name = `"PREFIX``PHASE``_phase`"; \
          static function PREFIX``PHASE``_phase get(); \
            if(m_inst == null) begin \
              m_inst = new; \
            end \
            return m_inst; \
          endfunction \
          protected function new(string name=`"PHASE`"); \
            super.new(name); \
          endfunction \
          virtual function string get_type_name(); \
            return type_name; \
          endfunction \
        endclass \

`define m_uvm_topdown_phase(PHASE,COMP,PREFIX) \
        class PREFIX``PHASE``_phase extends uvm_topdown_phase; \
          virtual function void exec_func(uvm_component comp, uvm_phase phase); \
            COMP comp_; \
            if ($cast(comp_,comp)) \
              comp_.``PHASE``_phase(phase); \
          endfunction \
          local static PREFIX``PHASE``_phase m_inst; \
          static const string type_name = `"PREFIX``PHASE``_phase`"; \
          static function PREFIX``PHASE``_phase get(); \
            if(m_inst == null) begin \
              m_inst = new(); \
            end \
            return m_inst; \
          endfunction \
          protected function new(string name=`"PHASE`"); \
            super.new(name); \
          endfunction \
          virtual function string get_type_name(); \
            return type_name; \
          endfunction \
        endclass \

`define m_uvm_bottomup_phase(PHASE,COMP,PREFIX) \
        class PREFIX``PHASE``_phase extends uvm_bottomup_phase; \
          virtual function void exec_func(uvm_component comp, uvm_phase phase); \
            COMP comp_; \
            if ($cast(comp_,comp)) \
              comp_.``PHASE``_phase(phase); \
          endfunction \
          static PREFIX``PHASE``_phase m_inst; \
          static const string type_name = `"PREFIX``PHASE``_phase`"; \
          static function PREFIX``PHASE``_phase get(); \
            if(m_inst == null) begin \
              m_inst = new(); \
            end \
            return m_inst; \
          endfunction \
          protected function new(string name=`"PHASE`"); \
            super.new(name); \
          endfunction \
          virtual function string get_type_name(); \
            return type_name; \
          endfunction \
        endclass \

`define uvm_builtin_task_phase(PHASE) \
        `m_uvm_task_phase(PHASE,uvm_component,uvm_)

`define uvm_builtin_topdown_phase(PHASE) \
        `m_uvm_topdown_phase(PHASE,uvm_component,uvm_)

`define uvm_builtin_bottomup_phase(PHASE) \
        `m_uvm_bottomup_phase(PHASE,uvm_component,uvm_)


`define uvm_user_task_phase(PHASE,COMP,PREFIX) \
        `m_uvm_task_phase(PHASE,COMP,PREFIX)

`define uvm_user_topdown_phase(PHASE,COMP,PREFIX) \
        `m_uvm_topdown_phase(PHASE,COMP,PREFIX)

`define uvm_user_bottomup_phase(PHASE,COMP,PREFIX) \
        `m_uvm_bottomup_phase(PHASE,COMP,PREFIX)

`endif



`ifndef UVM_OBJECT_DEFINES_SVH
`define UVM_OBJECT_DEFINES_SVH

`ifdef UVM_EMPTY_MACROS

`define uvm_field_utils_begin(T) 
`define uvm_field_utils_end 
`define uvm_object_utils(T) 
`define uvm_object_param_utils(T) 
`define uvm_object_utils_begin(T) 
`define uvm_object_param_utils_begin(T) 
`define uvm_object_utils_end
`define uvm_component_utils(T)
`define uvm_component_param_utils(T)
`define uvm_component_utils_begin(T)
`define uvm_component_param_utils_begin(T)
`define uvm_component_utils_end
`define uvm_field_int(ARG,FLAG)
`define uvm_field_real(ARG,FLAG)
`define uvm_field_enum(T,ARG,FLAG)
`define uvm_field_object(ARG,FLAG)
`define uvm_field_event(ARG,FLAG)
`define uvm_field_string(ARG,FLAG)
`define uvm_field_array_enum(ARG,FLAG)
`define uvm_field_array_int(ARG,FLAG)
`define uvm_field_sarray_int(ARG,FLAG)
`define uvm_field_sarray_enum(ARG,FLAG)
`define uvm_field_array_object(ARG,FLAG)
`define uvm_field_sarray_object(ARG,FLAG)
`define uvm_field_array_string(ARG,FLAG)
`define uvm_field_sarray_string(ARG,FLAG)
`define uvm_field_queue_enum(ARG,FLAG)
`define uvm_field_queue_int(ARG,FLAG)
`define uvm_field_queue_object(ARG,FLAG)
`define uvm_field_queue_string(ARG,FLAG)
`define uvm_field_aa_int_string(ARG, FLAG)
`define uvm_field_aa_string_string(ARG, FLAG)
`define uvm_field_aa_object_string(ARG, FLAG)
`define uvm_field_aa_int_int(ARG, FLAG)
`define uvm_field_aa_int_int(ARG, FLAG)
`define uvm_field_aa_int_int_unsigned(ARG, FLAG)
`define uvm_field_aa_int_integer(ARG, FLAG)
`define uvm_field_aa_int_integer_unsigned(ARG, FLAG)
`define uvm_field_aa_int_byte(ARG, FLAG)
`define uvm_field_aa_int_byte_unsigned(ARG, FLAG)
`define uvm_field_aa_int_shortint(ARG, FLAG)
`define uvm_field_aa_int_shortint_unsigned(ARG, FLAG)
`define uvm_field_aa_int_longint(ARG, FLAG)
`define uvm_field_aa_int_longint_unsigned(ARG, FLAG)
`define uvm_field_aa_int_key(KEY, ARG, FLAG)
`define uvm_field_aa_string_int(ARG, FLAG)
`define uvm_field_aa_object_int(ARG, FLAG)

`else


`ifdef UVM_NO_DEPRECATED 
  `define UVM_NO_REGISTERED_CONVERTER
`endif



`define uvm_field_utils_begin(T) \
   function void __m_uvm_field_automation (uvm_object tmp_data__, \
                                     int what__, \
                                     string str__); \
   begin \
     T local_data__;  \
     typedef T ___local_type____; \
     string string_aa_key;  \
     uvm_object __current_scopes[$]; \
     if(what__ inside {UVM_SETINT,UVM_SETSTR,UVM_SETOBJ}) begin \
        if(__m_uvm_status_container.m_do_cycle_check(this)) begin \
            return; \
        end \
        else \
            __current_scopes=__m_uvm_status_container.m_uvm_cycle_scopes; \
     end \
     super.__m_uvm_field_automation(tmp_data__, what__, str__); \
     if(tmp_data__ != null) \
       if(!$cast(local_data__, tmp_data__)) return;

`define uvm_field_utils_end \
     if(what__ inside {UVM_SETINT,UVM_SETSTR,UVM_SETOBJ}) begin \
        void'(__current_scopes.pop_back()); \
        __m_uvm_status_container.m_uvm_cycle_scopes = __current_scopes; \
     end \
     end \
endfunction \


`define uvm_object_utils(T) \
  `uvm_object_utils_begin(T) \
  `uvm_object_utils_end

`define uvm_object_param_utils(T) \
  `uvm_object_param_utils_begin(T) \
  `uvm_object_utils_end

`define uvm_object_utils_begin(T) \
   `m_uvm_object_registry_internal(T,T)  \
   `m_uvm_object_create_func(T) \
   `m_uvm_get_type_name_func(T) \
   `uvm_field_utils_begin(T) 

`define uvm_object_param_utils_begin(T) \
   `m_uvm_object_registry_param(T)  \
   `m_uvm_object_create_func(T) \
   `uvm_field_utils_begin(T) 
       
`define uvm_object_utils_end \
     end \
   endfunction \


`define uvm_component_utils(T) \
   `m_uvm_component_registry_internal(T,T) \
   `m_uvm_get_type_name_func(T) \

`define uvm_component_param_utils(T) \
   `m_uvm_component_registry_param(T) \

   
`define uvm_component_utils_begin(T) \
   `uvm_component_utils(T) \
   `uvm_field_utils_begin(T) 

`define uvm_component_param_utils_begin(T) \
   `uvm_component_param_utils(T) \
   `uvm_field_utils_begin(T) 

`define uvm_component_utils_end \
     end \
   endfunction



`define uvm_object_registry(T,S) \
   typedef uvm_object_registry#(T,S) type_id; \
   static function type_id get_type(); \
     return type_id::get(); \
   endfunction \
   virtual function uvm_object_wrapper get_object_type(); \
     return type_id::get(); \
   endfunction 



`define uvm_component_registry(T,S) \
   typedef uvm_component_registry #(T,S) type_id; \
   static function type_id get_type(); \
     return type_id::get(); \
   endfunction \
   virtual function uvm_object_wrapper get_object_type(); \
     return type_id::get(); \
   endfunction 



`define uvm_new_func \
  function new (string name, uvm_component parent); \
    super.new(name, parent); \
  endfunction




`define m_uvm_object_create_func(T) \
   function uvm_object create (string name=""); \
     T tmp; \
`ifdef UVM_OBJECT_DO_NOT_NEED_CONSTRUCTOR \
     tmp = new(); \
     if (name!="") \
       tmp.set_name(name); \
`else \
     if (name=="") tmp = new(); \
     else tmp = new(name); \
`endif \
     return tmp; \
   endfunction



`define m_uvm_get_type_name_func(T) \
   const static string type_name = `"T`"; \
   virtual function string get_type_name (); \
     return type_name; \
   endfunction 



`define m_uvm_object_registry_internal(T,S) \
   typedef uvm_object_registry#(T,`"S`") type_id; \
   static function type_id get_type(); \
     return type_id::get(); \
   endfunction \
   virtual function uvm_object_wrapper get_object_type(); \
     return type_id::get(); \
   endfunction 



`define m_uvm_object_registry_param(T) \
   typedef uvm_object_registry #(T) type_id; \
   static function type_id get_type(); \
     return type_id::get(); \
   endfunction \
   virtual function uvm_object_wrapper get_object_type(); \
     return type_id::get(); \
   endfunction 



`define m_uvm_component_registry_internal(T,S) \
   typedef uvm_component_registry #(T,`"S`") type_id; \
   static function type_id get_type(); \
     return type_id::get(); \
   endfunction \
   virtual function uvm_object_wrapper get_object_type(); \
     return type_id::get(); \
   endfunction



`define m_uvm_component_registry_param(T) \
   typedef uvm_component_registry #(T) type_id; \
   static function type_id get_type(); \
     return type_id::get(); \
   endfunction \
   virtual function uvm_object_wrapper get_object_type(); \
     return type_id::get(); \
   endfunction


`define uvm_field_int(ARG,FLAG) \
  begin \
    case (what__) \
      UVM_CHECK_FIELDS: \
        begin \
          __m_uvm_status_container.do_field_check(`"ARG`", this); \
        end \
      UVM_COPY: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOPY)) ARG = local_data__.ARG; \
        end \
      UVM_COMPARE: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOMPARE)) begin \
            if(ARG !== local_data__.ARG) begin \
               void'(__m_uvm_status_container.comparer.compare_field(`"ARG`", ARG, local_data__.ARG, $bits(ARG))); \
               if(__m_uvm_status_container.comparer.result && (__m_uvm_status_container.comparer.show_max <= __m_uvm_status_container.comparer.result)) return; \
            end \
          end \
        end \
      UVM_PACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          if($bits(ARG) <= 64) __m_uvm_status_container.packer.pack_field_int(ARG, $bits(ARG)); \
          else __m_uvm_status_container.packer.pack_field(ARG, $bits(ARG)); \
        end \
      UVM_UNPACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          if($bits(ARG) <= 64) ARG =  __m_uvm_status_container.packer.unpack_field_int($bits(ARG)); \
          else ARG = __m_uvm_status_container.packer.unpack_field($bits(ARG)); \
        end \
      UVM_RECORD: \
        `m_uvm_record_int(ARG, FLAG) \
      UVM_PRINT: \
        `m_uvm_print_int(ARG, FLAG) \
      UVM_SETINT: \
        begin \
          bit matched; \
          __m_uvm_status_container.scope.set_arg(`"ARG`"); \
          matched = uvm_is_match(str__, __m_uvm_status_container.scope.get()); \
          if(matched) begin \
            if((FLAG)&UVM_READONLY) begin \
              uvm_report_warning("RDONLY", $sformatf("Readonly argument match %s is ignored",  \
                 __m_uvm_status_container.get_full_scope_arg()), UVM_NONE); \
            end \
            else begin \
              if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
              ARG = uvm_object::__m_uvm_status_container.bitstream; \
              uvm_object::__m_uvm_status_container.status = 1; \
            end \
          end \
          __m_uvm_status_container.scope.unset_arg(`"ARG`"); \
        end \
    endcase \
  end



`define uvm_field_object(ARG,FLAG) \
  begin \
    case (what__) \
      UVM_CHECK_FIELDS: \
        __m_uvm_status_container.do_field_check(`"ARG`", this); \
      UVM_COPY: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOPY)) begin \
            if((FLAG)&UVM_REFERENCE || local_data__.ARG == null) ARG = local_data__.ARG; \
            else begin \
              uvm_object l_obj; \
              if(local_data__.ARG.get_name() == "") local_data__.ARG.set_name(`"ARG`"); \
              l_obj = local_data__.ARG.clone(); \
              if(l_obj == null) begin \
                `uvm_fatal("FAILCLN", $sformatf("Failure to clone %s.ARG, thus the variable will remain null.", local_data__.get_name())); \
              end \
              else begin \
                $cast(ARG, l_obj); \
                ARG.set_name(local_data__.ARG.get_name()); \
              end \
            end \
          end \
        end \
      UVM_COMPARE: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOMPARE)) begin \
            void'(__m_uvm_status_container.comparer.compare_object(`"ARG`", ARG, local_data__.ARG)); \
            if(__m_uvm_status_container.comparer.result && (__m_uvm_status_container.comparer.show_max <= __m_uvm_status_container.comparer.result)) return; \
          end \
        end \
      UVM_PACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          if(((FLAG)&UVM_NOPACK) == 0 && ((FLAG)&UVM_REFERENCE) == 0) \
            __m_uvm_status_container.packer.pack_object(ARG); \
        end \
      UVM_UNPACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          if(((FLAG)&UVM_NOPACK) == 0 && ((FLAG)&UVM_REFERENCE) == 0) \
            __m_uvm_status_container.packer.unpack_object(ARG); \
        end \
      UVM_RECORD: \
        `m_uvm_record_object(ARG,FLAG) \
      UVM_PRINT: \
        begin \
          if(!((FLAG)&UVM_NOPRINT)) begin \
            if(((FLAG)&UVM_REFERENCE) != 0) \
              __m_uvm_status_container.printer.print_object_header(`"ARG`", ARG); \
            else \
              __m_uvm_status_container.printer.print_object(`"ARG`", ARG); \
          end \
        end \
      UVM_SETINT: \
        begin \
          if((ARG != null) && (((FLAG)&UVM_READONLY)==0) && (((FLAG)&UVM_REFERENCE)==0)) begin \
            __m_uvm_status_container.scope.down(`"ARG`"); \
            ARG.__m_uvm_field_automation(null, UVM_SETINT, str__); \
            __m_uvm_status_container.scope.up(); \
          end \
        end \
      UVM_SETSTR: \
        begin \
          if((ARG != null) && (((FLAG)&UVM_READONLY)==0) && (((FLAG)&UVM_REFERENCE)==0)) begin \
            __m_uvm_status_container.scope.down(`"ARG`"); \
            ARG.__m_uvm_field_automation(null, UVM_SETSTR, str__); \
            __m_uvm_status_container.scope.up(); \
          end \
        end \
      UVM_SETOBJ: \
        begin \
          __m_uvm_status_container.scope.set_arg(`"ARG`"); \
          if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
            if((FLAG)&UVM_READONLY) begin \
              uvm_report_warning("RDONLY", $sformatf("Readonly argument match %s is ignored",  \
                 __m_uvm_status_container.get_full_scope_arg()), UVM_NONE); \
            end \
            else begin \
              if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_object()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
              if($cast(ARG,uvm_object::__m_uvm_status_container.object)) \
                uvm_object::__m_uvm_status_container.status = 1; \
            end \
          end \
          else if(ARG!=null && ((FLAG)&UVM_READONLY) == 0) begin \
            int cnt; \
            for(cnt=0; cnt<str__.len(); ++cnt) begin \
              if(str__[cnt] == "." || str__[cnt] == "*") break; \
            end \
            if(cnt!=str__.len()) begin \
              __m_uvm_status_container.scope.down(`"ARG`"); \
              ARG.__m_uvm_field_automation(null, UVM_SETOBJ, str__); \
              __m_uvm_status_container.scope.up(); \
            end \
          end \
        end \
    endcase \
  end



`define uvm_field_string(ARG,FLAG) \
  begin \
    case (what__) \
      UVM_CHECK_FIELDS: \
        __m_uvm_status_container.do_field_check(`"ARG`", this); \
      UVM_COPY: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOPY)) ARG = local_data__.ARG; \
        end \
      UVM_COMPARE: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOMPARE)) begin \
            if(ARG != local_data__.ARG) begin \
               void'(__m_uvm_status_container.comparer.compare_string(`"ARG`", ARG, local_data__.ARG)); \
               if(__m_uvm_status_container.comparer.result && (__m_uvm_status_container.comparer.show_max <= __m_uvm_status_container.comparer.result)) return; \
            end \
          end \
        end \
      UVM_PACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          __m_uvm_status_container.packer.pack_string(ARG); \
        end \
      UVM_UNPACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          ARG = __m_uvm_status_container.packer.unpack_string(); \
        end \
      UVM_RECORD: \
        `m_uvm_record_string(ARG, ARG, FLAG) \
      UVM_PRINT: \
        if(!((FLAG)&UVM_NOPRINT)) begin \
          __m_uvm_status_container.printer.print_string(`"ARG`", ARG); \
        end \
      UVM_SETSTR: \
        begin \
          __m_uvm_status_container.scope.set_arg(`"ARG`"); \
          if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
            if((FLAG)&UVM_READONLY) begin \
              uvm_report_warning("RDONLY", $sformatf("Readonly argument match %s is ignored",  \
                 __m_uvm_status_container.get_full_scope_arg()), UVM_NONE); \
            end \
            else begin \
              if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_str()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
              ARG = uvm_object::__m_uvm_status_container.stringv; \
              __m_uvm_status_container.status = 1; \
            end \
          end \
      end \
    endcase \
  end



`define uvm_field_enum(T,ARG,FLAG) \
  begin \
    case (what__) \
      UVM_CHECK_FIELDS: \
        __m_uvm_status_container.do_field_check(`"ARG`", this); \
      UVM_COPY: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOPY)) ARG = local_data__.ARG; \
        end \
      UVM_COMPARE: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOMPARE)) begin \
            if(ARG !== local_data__.ARG) begin \
               __m_uvm_status_container.scope.set_arg(`"ARG`"); \
               $swrite(__m_uvm_status_container.stringv, "lhs = %0s : rhs = %0s", \
                 ARG.name(), local_data__.ARG.name()); \
               __m_uvm_status_container.comparer.print_msg(__m_uvm_status_container.stringv); \
               if(__m_uvm_status_container.comparer.result && (__m_uvm_status_container.comparer.show_max <= __m_uvm_status_container.comparer.result)) return; \
            end \
          end \
        end \
      UVM_PACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          __m_uvm_status_container.packer.pack_field(ARG, $bits(ARG)); \
        end \
      UVM_UNPACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          ARG =  T'(__m_uvm_status_container.packer.unpack_field_int($bits(ARG))); \
        end \
      UVM_RECORD: \
        `m_uvm_record_string(ARG, ARG.name(), FLAG) \
      UVM_PRINT: \
        if(!((FLAG)&UVM_NOPRINT)) begin \
          __m_uvm_status_container.printer.print_generic(`"ARG`", `"T`", $bits(ARG), ARG.name()); \
        end \
      UVM_SETINT: \
        begin \
          __m_uvm_status_container.scope.set_arg(`"ARG`"); \
          if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
            if((FLAG)&UVM_READONLY) begin \
              uvm_report_warning("RDONLY", $sformatf("Readonly argument match %s is ignored",  \
                 __m_uvm_status_container.get_full_scope_arg()), UVM_NONE); \
            end \
            else begin \
              if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
              ARG = T'(uvm_object::__m_uvm_status_container.bitstream); \
              __m_uvm_status_container.status = 1; \
            end \
          end \
        end \
      UVM_SETSTR: \
        begin \
          __m_uvm_status_container.scope.set_arg(`"ARG`"); \
          if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
            if((FLAG)&UVM_READONLY) begin \
              uvm_report_warning("RDONLY", $sformatf("Readonly argument match %s is ignored",  \
                 __m_uvm_status_container.get_full_scope_arg()), UVM_NONE); \
            end \
            else begin \
              if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_str()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
              void'(uvm_enum_wrapper#(T)::from_name(uvm_object::__m_uvm_status_container.stringv, ARG)); \
              __m_uvm_status_container.status = 1; \
            end \
          end \
      end \
    endcase \
  end



`define uvm_field_real(ARG,FLAG) \
  begin \
    case (what__) \
      UVM_CHECK_FIELDS: \
        __m_uvm_status_container.do_field_check(`"ARG`", this); \
      UVM_COPY: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOPY)) ARG = local_data__.ARG; \
        end \
      UVM_COMPARE: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOMPARE)) begin \
            if(ARG != local_data__.ARG) begin \
               void'(__m_uvm_status_container.comparer.compare_field_real(`"ARG`", ARG, local_data__.ARG)); \
               if(__m_uvm_status_container.comparer.result && (__m_uvm_status_container.comparer.show_max <= __m_uvm_status_container.comparer.result)) return; \
            end \
          end \
        end \
      UVM_PACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          __m_uvm_status_container.packer.pack_field_int($realtobits(ARG), 64); \
        end \
      UVM_UNPACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          ARG = $bitstoreal(__m_uvm_status_container.packer.unpack_field_int(64)); \
        end \
      UVM_RECORD: \
        if(!((FLAG)&UVM_NORECORD)) begin \
          __m_uvm_status_container.recorder.record_field_real(`"ARG`", ARG); \
        end \
      UVM_PRINT: \
        if(!((FLAG)&UVM_NOPRINT)) begin \
          __m_uvm_status_container.printer.print_real(`"ARG`", ARG); \
        end \
      UVM_SETINT: \
        begin \
          __m_uvm_status_container.scope.set_arg(`"ARG`"); \
          if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
            if((FLAG)&UVM_READONLY) begin \
              uvm_report_warning("RDONLY", $sformatf("Readonly argument match %s is ignored",  \
                 __m_uvm_status_container.get_full_scope_arg()), UVM_NONE); \
            end \
            else begin \
              if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
              ARG = $bitstoreal(uvm_object::__m_uvm_status_container.bitstream); \
              __m_uvm_status_container.status = 1; \
            end \
          end \
      end \
    endcase \
  end



`define uvm_field_event(ARG,FLAG) \
  begin \
    case (what__) \
      UVM_COPY: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOPY)) ARG = local_data__.ARG; \
        end \
      UVM_COMPARE: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOMPARE)) begin \
            if(ARG != local_data__.ARG) begin \
               __m_uvm_status_container.scope.down(`"ARG`"); \
               __m_uvm_status_container.comparer.print_msg(""); \
               if(__m_uvm_status_container.comparer.result && (__m_uvm_status_container.comparer.show_max <= __m_uvm_status_container.comparer.result)) return; \
            end \
          end \
        end \
      UVM_PACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
        end \
      UVM_UNPACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
        end \
      UVM_RECORD: \
        begin \
        end \
      UVM_PRINT: \
        if(!((FLAG)&UVM_NOPRINT)) begin \
          __m_uvm_status_container.printer.print_generic(`"ARG`", "event", -1, ""); \
        end \
      UVM_SETINT: \
        begin \
        end \
    endcase \
  end




`define uvm_field_sarray_int(ARG,FLAG) \
  begin \
    case (what__) \
      UVM_CHECK_FIELDS: \
        __m_uvm_status_container.do_field_check(`"ARG`", this); \
      UVM_COPY: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOPY)) ARG = local_data__.ARG; \
        end \
      UVM_COMPARE: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOMPARE)) begin \
            if(ARG !== local_data__.ARG) begin \
               if(__m_uvm_status_container.comparer.show_max == 1) begin \
                 __m_uvm_status_container.scope.set_arg(`"ARG`"); \
                 __m_uvm_status_container.comparer.print_msg(""); \
               end \
               else if(__m_uvm_status_container.comparer.show_max) begin \
                 foreach(ARG[i]) begin \
                   if(ARG[i] !== local_data__.ARG[i]) begin \
                     __m_uvm_status_container.scope.set_arg_element(`"ARG`",i); \
                     void'(__m_uvm_status_container.comparer.compare_field("", ARG[i], local_data__.ARG[i], $bits(ARG[i]))); \
                   end \
                 end \
               end \
               else if ((__m_uvm_status_container.comparer.physical&&((FLAG)&UVM_PHYSICAL)) || \
                        (__m_uvm_status_container.comparer.abstract&&((FLAG)&UVM_ABSTRACT)) || \
                        (!((FLAG)&UVM_PHYSICAL) && !((FLAG)&UVM_ABSTRACT)) ) \
                 __m_uvm_status_container.comparer.result++; \
               if(__m_uvm_status_container.comparer.result && (__m_uvm_status_container.comparer.show_max <= __m_uvm_status_container.comparer.result)) return; \
            end \
          end \
        end \
      UVM_PACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          foreach(ARG[i])  \
            if($bits(ARG[i]) <= 64) __m_uvm_status_container.packer.pack_field_int(ARG[i], $bits(ARG[i])); \
            else __m_uvm_status_container.packer.pack_field(ARG[i], $bits(ARG[i])); \
        end \
      UVM_UNPACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          foreach(ARG[i]) \
            if($bits(ARG[i]) <= 64) ARG[i] = __m_uvm_status_container.packer.unpack_field_int($bits(ARG[i])); \
            else ARG[i] = __m_uvm_status_container.packer.unpack_field($bits(ARG[i])); \
        end \
      UVM_RECORD: \
        `m_uvm_record_qda_int(ARG, FLAG, $size(ARG))  \
      UVM_PRINT: \
        if(!((FLAG)&UVM_NOPRINT)) begin \
          if(((FLAG)&UVM_NOPRINT) == 0) begin \
             `uvm_print_sarray_int3(ARG, uvm_radix_enum'((FLAG)&(UVM_RADIX)), \
                                   __m_uvm_status_container.printer) \
          end \
        end \
      UVM_SETINT: \
        begin \
          __m_uvm_status_container.scope.set_arg(`"ARG`"); \
          if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
            if((FLAG)&UVM_READONLY) begin \
              uvm_report_warning("RDONLY", $sformatf("Readonly argument match %s is ignored",  \
                 __m_uvm_status_container.get_full_scope_arg()), UVM_NONE); \
            end \
            else begin \
              uvm_report_warning("RDONLY", $sformatf("%s: static arrays cannot be resized via configuraton.",  \
                 __m_uvm_status_container.get_full_scope_arg()), UVM_NONE); \
            end \
          end \
          else if(!((FLAG)&UVM_READONLY)) begin \
            foreach(ARG[i]) begin \
              __m_uvm_status_container.scope.set_arg_element(`"ARG`",i); \
              if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
                if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
                ARG[i] =  uvm_object::__m_uvm_status_container.bitstream; \
                __m_uvm_status_container.status = 1; \
              end \
            end \
          end \
        end \
    endcase \
  end



`define uvm_field_sarray_object(ARG,FLAG) \
  begin \
    case (what__) \
      UVM_CHECK_FIELDS: \
        __m_uvm_status_container.do_field_check(`"ARG`", this); \
      UVM_COPY: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOPY)) begin \
            if(((FLAG)&UVM_REFERENCE)) \
              ARG = local_data__.ARG; \
            else \
              foreach(ARG[i]) begin \
                if(ARG[i] != null && local_data__.ARG[i] != null) \
                  ARG[i].copy(local_data__.ARG[i]); \
                else if(ARG[i] == null && local_data__.ARG[i] != null) \
                  $cast(ARG[i], local_data__.ARG[i].clone()); \
                else \
                  ARG[i] = null; \
              end \
          end \
        end \
      UVM_COMPARE: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOMPARE)) begin \
            if(((FLAG)&UVM_REFERENCE) && (__m_uvm_status_container.comparer.show_max <= 1) && (ARG !== local_data__.ARG) ) begin \
               if(__m_uvm_status_container.comparer.show_max == 1) begin \
                 __m_uvm_status_container.scope.set_arg(`"ARG`"); \
                 __m_uvm_status_container.comparer.print_msg(""); \
               end \
               else if ((__m_uvm_status_container.comparer.physical&&((FLAG)&UVM_PHYSICAL)) || \
                        (__m_uvm_status_container.comparer.abstract&&((FLAG)&UVM_ABSTRACT)) || \
                        (!((FLAG)&UVM_PHYSICAL) && !((FLAG)&UVM_ABSTRACT)) ) \
                 __m_uvm_status_container.comparer.result++; \
               if(__m_uvm_status_container.comparer.result && (__m_uvm_status_container.comparer.show_max <= __m_uvm_status_container.comparer.result)) return; \
            end \
            else begin \
              string s; \
              foreach(ARG[i]) begin \
                if(ARG[i] != null && local_data__.ARG[i] != null) begin \
                  $swrite(s,`"ARG[%0d]`",i); \
                  void'(__m_uvm_status_container.comparer.compare_object(s, ARG[i], local_data__.ARG[i])); \
                end \
                if(__m_uvm_status_container.comparer.result && (__m_uvm_status_container.comparer.show_max <= __m_uvm_status_container.comparer.result)) return; \
              end \
            end \
          end \
        end \
      UVM_PACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          foreach(ARG[i])  \
            __m_uvm_status_container.packer.pack_object(ARG[i]); \
        end \
      UVM_UNPACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          foreach(ARG[i]) \
            __m_uvm_status_container.packer.unpack_object(ARG[i]); \
        end \
      UVM_RECORD: \
        `m_uvm_record_qda_object(ARG,FLAG,$size(ARG)) \
      UVM_PRINT: \
        begin \
          if(((FLAG)&UVM_NOPRINT) == 0) begin \
             `uvm_print_sarray_object3(ARG, __m_uvm_status_container.printer, FLAG) \
          end \
        end \
      UVM_SETINT: \
        begin \
          string s; \
          if(!((FLAG)&UVM_READONLY)) begin \
            foreach(ARG[i]) begin \
              $swrite(s,`"ARG[%0d]`",i); \
              __m_uvm_status_container.scope.set_arg(s); \
              if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
                if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_object()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
                if($cast(ARG[i],uvm_object::__m_uvm_status_container.object)) \
                  uvm_object::__m_uvm_status_container.status = 1; \
              end \
              else if(ARG[i]!=null && !((FLAG)&UVM_REFERENCE)) begin \
                int cnt; \
                for(cnt=0; cnt<str__.len(); ++cnt) begin \
                  if(str__[cnt] == "." || str__[cnt] == "*") break; \
                end \
                if(cnt!=str__.len()) begin \
                  __m_uvm_status_container.scope.down(s); \
                  ARG[i].__m_uvm_field_automation(null, UVM_SETINT, str__); \
                  __m_uvm_status_container.scope.up(); \
                end \
              end \
            end \
          end \
        end \
      UVM_SETSTR: \
        begin \
          string s; \
          if(!((FLAG)&UVM_READONLY)) begin \
            foreach(ARG[i]) begin \
              $swrite(s,`"ARG[%0d]`",i); \
              __m_uvm_status_container.scope.set_arg(s); \
              if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
                if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_object()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
                if($cast(ARG[i],uvm_object::__m_uvm_status_container.object)) \
                  uvm_object::__m_uvm_status_container.status = 1; \
              end \
              else if(ARG[i]!=null && !((FLAG)&UVM_REFERENCE)) begin \
                int cnt; \
                for(cnt=0; cnt<str__.len(); ++cnt) begin \
                  if(str__[cnt] == "." || str__[cnt] == "*") break; \
                end \
                if(cnt!=str__.len()) begin \
                  __m_uvm_status_container.scope.down(s); \
                  ARG[i].__m_uvm_field_automation(null, UVM_SETSTR, str__); \
                  __m_uvm_status_container.scope.up(); \
                end \
              end \
            end \
          end \
        end \
      UVM_SETOBJ: \
        begin \
          string s; \
          if(!((FLAG)&UVM_READONLY)) begin \
            foreach(ARG[i]) begin \
              $swrite(s,`"ARG[%0d]`",i); \
              __m_uvm_status_container.scope.set_arg(s); \
              if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
                if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_object()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
                if($cast(ARG[i],uvm_object::__m_uvm_status_container.object)) \
                  uvm_object::__m_uvm_status_container.status = 1; \
              end \
              else if(ARG[i]!=null && !((FLAG)&UVM_REFERENCE)) begin \
                int cnt; \
                for(cnt=0; cnt<str__.len(); ++cnt) begin \
                  if(str__[cnt] == "." || str__[cnt] == "*") break; \
                end \
                if(cnt!=str__.len()) begin \
                  __m_uvm_status_container.scope.down(s); \
                  ARG[i].__m_uvm_field_automation(null, UVM_SETOBJ, str__); \
                  __m_uvm_status_container.scope.up(); \
                end \
              end \
            end \
          end \
        end \
    endcase \
  end



`define uvm_field_sarray_string(ARG,FLAG) \
  begin \
    case (what__) \
      UVM_CHECK_FIELDS: \
        __m_uvm_status_container.do_field_check(`"ARG`", this); \
      UVM_COPY: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOPY)) ARG = local_data__.ARG; \
        end \
      UVM_COMPARE: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOMPARE)) begin \
            if(ARG != local_data__.ARG) begin \
               if(__m_uvm_status_container.comparer.show_max == 1) begin \
                 __m_uvm_status_container.scope.set_arg(`"ARG`"); \
                 __m_uvm_status_container.comparer.print_msg(""); \
               end \
               else if(__m_uvm_status_container.comparer.show_max) begin \
                 foreach(ARG[i]) begin \
                   if(ARG[i] != local_data__.ARG[i]) begin \
                     __m_uvm_status_container.scope.set_arg_element(`"ARG`",i); \
                     void'(__m_uvm_status_container.comparer.compare_string("", ARG[i], local_data__.ARG[i])); \
                   end \
                 end \
               end \
               else if ((__m_uvm_status_container.comparer.physical&&((FLAG)&UVM_PHYSICAL)) || \
                        (__m_uvm_status_container.comparer.abstract&&((FLAG)&UVM_ABSTRACT)) || \
                        (!((FLAG)&UVM_PHYSICAL) && !((FLAG)&UVM_ABSTRACT)) ) \
                 __m_uvm_status_container.comparer.result++; \
               if(__m_uvm_status_container.comparer.result && (__m_uvm_status_container.comparer.show_max <= __m_uvm_status_container.comparer.result)) return; \
            end \
          end \
        end \
      UVM_PACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          foreach(ARG[i])  \
            __m_uvm_status_container.packer.pack_string(ARG[i]); \
        end \
      UVM_UNPACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          foreach(ARG[i]) \
            ARG[i] = __m_uvm_status_container.packer.unpack_string(); \
        end \
      UVM_RECORD: \
        begin \
          int sz; foreach(ARG[i]) sz=i; \
          `m_uvm_record_qda_string(ARG, FLAG, sz) \
        end \
      UVM_PRINT: \
        begin \
          if(((FLAG)&UVM_NOPRINT) == 0) begin \
             `uvm_print_sarray_string2(ARG, __m_uvm_status_container.printer) \
          end \
        end \
      UVM_SETSTR: \
        begin \
          __m_uvm_status_container.scope.set_arg(`"ARG`"); \
          if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
            if((FLAG)&UVM_READONLY) begin \
              uvm_report_warning("RDONLY", $sformatf("Readonly argument match %s is ignored",  \
                 __m_uvm_status_container.get_full_scope_arg()), UVM_NONE); \
            end \
            else begin \
              uvm_report_warning("RDONLY", {__m_uvm_status_container.get_full_scope_arg(), \
              ": static arrays cannot be resized via configuraton."}, UVM_NONE); \
            end \
          end \
          else if(!((FLAG)&UVM_READONLY)) begin \
            foreach(ARG[i]) begin \
              __m_uvm_status_container.scope.set_arg_element(`"ARG`",i); \
              if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
                if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
                ARG[i] =  uvm_object::__m_uvm_status_container.stringv; \
                __m_uvm_status_container.status = 1; \
              end \
            end \
          end \
        end \
    endcase \
  end



`define uvm_field_sarray_enum(T,ARG,FLAG) \
  begin \
    case (what__) \
      UVM_CHECK_FIELDS: \
        __m_uvm_status_container.do_field_check(`"ARG`", this); \
      UVM_COPY: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOPY)) ARG = local_data__.ARG; \
        end \
      UVM_COMPARE: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOMPARE)) begin \
            if(ARG !== local_data__.ARG) begin \
               if(__m_uvm_status_container.comparer.show_max == 1) begin \
                 __m_uvm_status_container.scope.set_arg(`"ARG`"); \
                 __m_uvm_status_container.comparer.print_msg(""); \
               end \
               else if(__m_uvm_status_container.comparer.show_max) begin \
                 foreach(ARG[i]) begin \
                   if(ARG[i] !== local_data__.ARG[i]) begin \
                     __m_uvm_status_container.scope.set_arg_element(`"ARG`",i); \
                     $swrite(__m_uvm_status_container.stringv, "lhs = %0s : rhs = %0s", \
                       ARG[i].name(), local_data__.ARG[i].name()); \
                     __m_uvm_status_container.comparer.print_msg(__m_uvm_status_container.stringv); \
                     if(__m_uvm_status_container.comparer.result && (__m_uvm_status_container.comparer.show_max <= __m_uvm_status_container.comparer.result)) return; \
                   end \
                 end \
               end \
               else if ((__m_uvm_status_container.comparer.physical&&((FLAG)&UVM_PHYSICAL)) || \
                        (__m_uvm_status_container.comparer.abstract&&((FLAG)&UVM_ABSTRACT)) || \
                        (!((FLAG)&UVM_PHYSICAL) && !((FLAG)&UVM_ABSTRACT)) ) \
                 __m_uvm_status_container.comparer.result++; \
               if(__m_uvm_status_container.comparer.result && (__m_uvm_status_container.comparer.show_max <= __m_uvm_status_container.comparer.result)) return; \
            end \
          end \
        end \
      UVM_PACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          foreach(ARG[i])  \
            __m_uvm_status_container.packer.pack_field_int(int'(ARG[i]), $bits(ARG[i])); \
        end \
      UVM_UNPACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          foreach(ARG[i]) \
            ARG[i] = T'(__m_uvm_status_container.packer.unpack_field_int($bits(ARG[i]))); \
        end \
      UVM_RECORD: \
        `m_uvm_record_qda_enum(ARG, FLAG, $size(ARG)) \
      UVM_PRINT: \
        begin \
          if(((FLAG)&UVM_NOPRINT) == 0) begin \
             `uvm_print_qda_enum(ARG, __m_uvm_status_container.printer, array, T) \
          end \
        end \
      UVM_SETINT: \
        begin \
          __m_uvm_status_container.scope.set_arg(`"ARG`"); \
          if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
            if((FLAG)&UVM_READONLY) begin \
              uvm_report_warning("RDONLY", $sformatf("Readonly argument match %s is ignored",  \
                 __m_uvm_status_container.get_full_scope_arg()), UVM_NONE); \
            end \
            else begin \
              uvm_report_warning("RDONLY", $sformatf("%s: static arrays cannot be resized via configuraton.",  \
                 __m_uvm_status_container.get_full_scope_arg()), UVM_NONE); \
            end \
          end \
          else if(!((FLAG)&UVM_READONLY)) begin \
            foreach(ARG[i]) begin \
              __m_uvm_status_container.scope.set_arg_element(`"ARG`",i); \
              if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
                if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
                ARG[i] =  T'(uvm_object::__m_uvm_status_container.bitstream); \
                __m_uvm_status_container.status = 1; \
              end \
            end \
          end \
        end \
      UVM_SETSTR: \
        begin \
          __m_uvm_status_container.scope.set_arg(`"ARG`"); \
          if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
            if((FLAG)&UVM_READONLY) begin \
              uvm_report_warning("RDONLY", $sformatf("Readonly argument match %s is ignored",  \
                 __m_uvm_status_container.get_full_scope_arg()), UVM_NONE); \
            end \
            else begin \
              uvm_report_warning("RDONLY", {__m_uvm_status_container.get_full_scope_arg(), \
              ": static arrays cannot be resized via configuraton."}, UVM_NONE); \
            end \
          end \
          else if(!((FLAG)&UVM_READONLY)) begin \
            foreach(ARG[i]) begin \
              __m_uvm_status_container.scope.set_arg_element(`"ARG`",i); \
              if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
	              T t__;  \
                if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
                void'(uvm_enum_wrapper#(T)::from_name(uvm_object::__m_uvm_status_container.stringv, t__)); ARG[i]=t__;\
                __m_uvm_status_container.status = 1; \
              end \
            end \
          end \
        end \
    endcase \
  end





`define M_UVM_QUEUE_RESIZE(ARG,VAL) \
  while(ARG.size()<sz) ARG.push_back(VAL); \
  while(ARG.size()>sz) void'(ARG.pop_front()); \



`define M_UVM_ARRAY_RESIZE(ARG,VAL) \
  ARG = new[sz](ARG); \



`define M_UVM_SARRAY_RESIZE(ARG,VAL) \



`define M_UVM_FIELD_QDA_INT(TYPE,ARG,FLAG) \
  begin \
    case (what__) \
      UVM_CHECK_FIELDS: \
        __m_uvm_status_container.do_field_check(`"ARG`", this); \
      UVM_COPY: \
        begin \
          if (local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOPY)) ARG = local_data__.ARG; \
        end \
      UVM_COMPARE: \
        begin \
          if (local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOMPARE)) begin \
            if(ARG !== local_data__.ARG) begin \
               if(__m_uvm_status_container.comparer.show_max == 1) begin \
                 __m_uvm_status_container.scope.set_arg(`"ARG`"); \
                 __m_uvm_status_container.comparer.print_msg(""); \
               end \
               else if(__m_uvm_status_container.comparer.show_max) begin \
                  if(ARG.size() != local_data__.ARG.size()) begin \
                    void'(__m_uvm_status_container.comparer.compare_field(`"ARG``.size`", ARG.size(), local_data__.ARG.size(), 32)); \
                  end \
                 else begin \
                   foreach(ARG[i]) begin \
                     if(ARG[i] !== local_data__.ARG[i]) begin \
                       __m_uvm_status_container.scope.set_arg_element(`"ARG`",i); \
                       void'(__m_uvm_status_container.comparer.compare_field("", ARG[i], local_data__.ARG[i], $bits(ARG[i]))); \
                     end \
                   end \
                 end \
               end \
               else if ((__m_uvm_status_container.comparer.physical&&((FLAG)&UVM_PHYSICAL)) || \
                        (__m_uvm_status_container.comparer.abstract&&((FLAG)&UVM_ABSTRACT)) || \
                        (!((FLAG)&UVM_PHYSICAL) && !((FLAG)&UVM_ABSTRACT)) ) \
                 __m_uvm_status_container.comparer.result++; \
               if(__m_uvm_status_container.comparer.result && (__m_uvm_status_container.comparer.show_max <= __m_uvm_status_container.comparer.result)) return; \
            end \
          end \
        end \
      UVM_PACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
           if(__m_uvm_status_container.packer.use_metadata) __m_uvm_status_container.packer.pack_field_int(ARG.size(), 32); \
          foreach(ARG[i])  \
            if($bits(ARG[i]) <= 64) __m_uvm_status_container.packer.pack_field_int(ARG[i], $bits(ARG[i])); \
            else __m_uvm_status_container.packer.pack_field(ARG[i], $bits(ARG[i])); \
        end \
      UVM_UNPACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
           int sz = ARG.size(); \
           if(__m_uvm_status_container.packer.use_metadata) sz = __m_uvm_status_container.packer.unpack_field_int(32); \
          if(sz != ARG.size()) begin \
          `M_UVM_``TYPE``_RESIZE (ARG,0) \
          end \
          foreach(ARG[i]) \
            if($bits(ARG[i]) <= 64) ARG[i] = __m_uvm_status_container.packer.unpack_field_int($bits(ARG[i])); \
            else ARG[i] = __m_uvm_status_container.packer.unpack_field($bits(ARG[i])); \
        end \
      UVM_RECORD: \
        `m_uvm_record_qda_int(ARG, FLAG, ARG.size()) \
      UVM_PRINT: \
        begin \
          if(((FLAG)&UVM_NOPRINT) == 0) begin \
             `uvm_print_array_int3(ARG, uvm_radix_enum'((FLAG)&(UVM_RADIX)), \
                                   __m_uvm_status_container.printer) \
          end \
        end \
      UVM_SETINT: \
        begin \
          __m_uvm_status_container.scope.set_arg(`"ARG`"); \
          if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
            if((FLAG)&UVM_READONLY) begin \
              uvm_report_warning("RDONLY", $sformatf("Readonly argument match %s is ignored",  \
                 __m_uvm_status_container.get_full_scope_arg()), UVM_NONE); \
            end \
             else begin \
               int sz =  uvm_object::__m_uvm_status_container.bitstream; \
               if (__m_uvm_status_container.print_matches) \
              uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
               if(ARG.size() !=  sz) begin \
                 `M_UVM_``TYPE``_RESIZE(ARG,0) \
               end \
               __m_uvm_status_container.status = 1; \
             end \
          end \
          else if(!((FLAG)&UVM_READONLY)) begin \
            bit wildcard_index__; \
            int index__; \
            index__ = uvm_get_array_index_int(str__, wildcard_index__); \
            if(uvm_is_array(str__)  && (index__ != -1)) begin\
              if(wildcard_index__) begin \
                for(index__=0; index__<ARG.size(); ++index__) begin \
                  if(uvm_is_match(str__, {__m_uvm_status_container.scope.get_arg(),$sformatf("[%0d]", index__)})) begin \
                    if (__m_uvm_status_container.print_matches) \
                      uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg(), $sformatf("[%0d]",index__)}, UVM_LOW); \
                    ARG[index__] = uvm_object::__m_uvm_status_container.bitstream; \
                    __m_uvm_status_container.status = 1; \
                  end \
                end \
              end \
              else if(uvm_is_match(str__, {__m_uvm_status_container.scope.get_arg(),$sformatf("[%0d]", index__)})) begin \
                if(index__+1 > ARG.size()) begin \
                  int sz = index__; \
                  int tmp__; \
                  `M_UVM_``TYPE``_RESIZE(ARG,tmp__) \
                end \
                if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
                ARG[index__] =  uvm_object::__m_uvm_status_container.bitstream; \
                __m_uvm_status_container.status = 1; \
              end \
            end \
          end \
        end \
    endcase \
  end



`define uvm_field_array_int(ARG,FLAG) \
   `M_UVM_FIELD_QDA_INT(ARRAY,ARG,FLAG) 



`define uvm_field_array_object(ARG,FLAG) \
  `M_UVM_FIELD_QDA_OBJECT(ARRAY,ARG,FLAG)

`define M_UVM_FIELD_QDA_OBJECT(TYPE,ARG,FLAG) \
  begin \
    case (what__) \
      UVM_CHECK_FIELDS: \
        __m_uvm_status_container.do_field_check(`"ARG`", this); \
      UVM_COPY: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOPY)) begin \
            if(((FLAG)&UVM_REFERENCE)) \
              ARG = local_data__.ARG; \
            else begin \
              int sz = local_data__.ARG.size(); \
              `M_UVM_``TYPE``_RESIZE(ARG,null) \
              foreach(ARG[i]) begin \
                if(ARG[i] != null && local_data__.ARG[i] != null) \
                  ARG[i].copy(local_data__.ARG[i]); \
                else if(ARG[i] == null && local_data__.ARG[i] != null) \
                  $cast(ARG[i], local_data__.ARG[i].clone()); \
                else \
                  ARG[i] = null; \
              end \
            end \
          end \
        end \
      UVM_COMPARE: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOMPARE)) begin \
            if(((FLAG)&UVM_REFERENCE) && (__m_uvm_status_container.comparer.show_max <= 1) && (ARG !== local_data__.ARG) ) begin \
               if(__m_uvm_status_container.comparer.show_max == 1) begin \
                 __m_uvm_status_container.scope.set_arg(`"ARG`"); \
                 __m_uvm_status_container.comparer.print_msg(""); \
               end \
               else if ((__m_uvm_status_container.comparer.physical&&((FLAG)&UVM_PHYSICAL)) || \
                        (__m_uvm_status_container.comparer.abstract&&((FLAG)&UVM_ABSTRACT)) || \
                        (!((FLAG)&UVM_PHYSICAL) && !((FLAG)&UVM_ABSTRACT)) ) \
                 __m_uvm_status_container.comparer.result++; \
               if(__m_uvm_status_container.comparer.result && (__m_uvm_status_container.comparer.show_max <= __m_uvm_status_container.comparer.result)) return; \
            end \
            else begin \
              string s; \
              if(ARG.size() != local_data__.ARG.size()) begin \
                __m_uvm_status_container.scope.set_arg(`"ARG`"); \
                __m_uvm_status_container.comparer.print_msg($sformatf("size mismatch: lhs: %0d  rhs: %0d", ARG.size(), local_data__.ARG.size())); \
              	if(__m_uvm_status_container.comparer.show_max == 1) return; \
              end \
              for(int i=0; i<ARG.size() && i<local_data__.ARG.size(); ++i) begin \
                if(ARG[i] != null && local_data__.ARG[i] != null) begin \
                  $swrite(s,`"ARG[%0d]`",i); \
                  void'(__m_uvm_status_container.comparer.compare_object(s, ARG[i], local_data__.ARG[i])); \
                end \
                if(__m_uvm_status_container.comparer.result && (__m_uvm_status_container.comparer.show_max <= __m_uvm_status_container.comparer.result)) return; \
              end \
            end \
          end \
        end \
      UVM_PACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          if(__m_uvm_status_container.packer.use_metadata) __m_uvm_status_container.packer.pack_field_int(ARG.size(), 32); \
          foreach(ARG[i])  \
            __m_uvm_status_container.packer.pack_object(ARG[i]); \
        end \
      UVM_UNPACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          int sz = ARG.size(); \
          if(__m_uvm_status_container.packer.use_metadata) sz = __m_uvm_status_container.packer.unpack_field_int(32); \
          if(sz != ARG.size()) begin \
            `M_UVM_``TYPE``_RESIZE(ARG,null) \
          end \
          foreach(ARG[i]) \
            __m_uvm_status_container.packer.unpack_object(ARG[i]); \
        end \
      UVM_RECORD: \
        `m_uvm_record_qda_object(ARG,FLAG,ARG.size()) \
      UVM_PRINT: \
        begin \
          if(((FLAG)&UVM_NOPRINT) == 0) begin \
             `uvm_print_array_object3(ARG, __m_uvm_status_container.printer,FLAG) \
          end \
        end \
      UVM_SETINT: \
        begin \
          __m_uvm_status_container.scope.set_arg(`"ARG`"); \
          if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
            if((FLAG)&UVM_READONLY) begin \
              uvm_report_warning("RDONLY", $sformatf("Readonly argument match %s is ignored",  \
                 __m_uvm_status_container.get_full_scope_arg()), UVM_NONE); \
            end \
            else begin \
              int sz =  uvm_object::__m_uvm_status_container.bitstream; \
              if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
              if(ARG.size() !=  sz) begin \
                `M_UVM_``TYPE``_RESIZE(ARG,null) \
              end \
              __m_uvm_status_container.status = 1; \
            end \
          end \
          else if(!((FLAG)&UVM_READONLY)) begin \
            foreach(ARG[i]) begin \
              string s; \
              $swrite(s,`"ARG[%0d]`",i); \
              __m_uvm_status_container.scope.set_arg(s); \
              if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
		 uvm_report_warning("STRMTC", {"set_int()", ": Match ignored for string ", str__, ". Cannot set object to int value."}); \
              end \
              else if(ARG[i]!=null && !((FLAG)&UVM_REFERENCE)) begin \
                int cnt; \
                for(cnt=0; cnt<str__.len(); ++cnt) begin \
                  if(str__[cnt] == "." || str__[cnt] == "*") break; \
                end \
                if(cnt!=str__.len()) begin \
                  __m_uvm_status_container.scope.down(s); \
                  ARG[i].__m_uvm_field_automation(null, UVM_SETINT, str__); \
                  __m_uvm_status_container.scope.up(); \
                end \
              end \
            end \
          end \
        end \
      UVM_SETSTR: \
        begin \
          __m_uvm_status_container.scope.set_arg(`"ARG`"); \
          if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
            if((FLAG)&UVM_READONLY) begin \
              uvm_report_warning("RDONLY", $sformatf("Readonly argument match %s is ignored",  \
                 __m_uvm_status_container.get_full_scope_arg()), UVM_NONE); \
            end \
            else begin \
                  uvm_report_warning("STRMTC", {"set_str()", ": Match ignored for string ", str__, ". Cannot set array of objects to string value."}); \
            end \
          end \
          else if(!((FLAG)&UVM_READONLY)) begin \
            foreach(ARG[i]) begin \
              string s; \
              $swrite(s,`"ARG[%0d]`",i); \
              __m_uvm_status_container.scope.set_arg(s); \
              if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
                  uvm_report_warning("STRMTC", {"set_str()", ": Match ignored for string ", str__, ". Cannot set object to string value."}); \
              end \
              else if(ARG[i]!=null && !((FLAG)&UVM_REFERENCE)) begin \
                int cnt; \
                for(cnt=0; cnt<str__.len(); ++cnt) begin \
                  if(str__[cnt] == "." || str__[cnt] == "*") break; \
                end \
                if(cnt!=str__.len()) begin \
                  __m_uvm_status_container.scope.down(s); \
                  ARG[i].__m_uvm_field_automation(null, UVM_SETSTR, str__); \
                  __m_uvm_status_container.scope.up(); \
                end \
              end \
            end \
          end \
        end \
      UVM_SETOBJ: \
        begin \
          string s; \
          if(!((FLAG)&UVM_READONLY)) begin \
            bit wildcard_index__; \
            int index__; \
            __m_uvm_status_container.scope.set_arg(`"ARG`"); \
            index__ = uvm_get_array_index_int(str__, wildcard_index__); \
            if(uvm_is_array(str__)  && (index__ != -1)) begin\
              if(wildcard_index__) begin \
                for(index__=0; index__<ARG.size(); ++index__) begin \
                  if(uvm_is_match(str__, {__m_uvm_status_container.scope.get_arg(),$sformatf("[%0d]", index__)})) begin \
                    if (__m_uvm_status_container.print_matches) \
                      uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg(), $sformatf("[%0d]",index__)}, UVM_LOW); \
                    $cast(ARG[index__], uvm_object::__m_uvm_status_container.object); \
                    __m_uvm_status_container.status = 1; \
                  end \
                end \
              end \
              else if(uvm_is_match(str__, {__m_uvm_status_container.get_full_scope_arg(),$sformatf("[%0d]", index__)})) begin \
                if(index__+1 > ARG.size()) begin \
                  int sz = index__+1; \
                  `M_UVM_``TYPE``_RESIZE(ARG,null) \
                end \
                if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
                $cast(ARG[index__],  uvm_object::__m_uvm_status_container.object); \
                __m_uvm_status_container.status = 1; \
              end \
            end \
            else if(!((FLAG)&UVM_REFERENCE)) begin \
              int cnt; \
              foreach(ARG[i]) begin \
                if (ARG[i]!=null) begin \
                  string s; \
                  $swrite(s,`"ARG[%0d]`",i); \
                for(cnt=0; cnt<str__.len(); ++cnt) begin \
                  if(str__[cnt] == "." || str__[cnt] == "*") break; \
                end \
                if(cnt!=str__.len()) begin \
                  __m_uvm_status_container.scope.down(s); \
                  ARG[i].__m_uvm_field_automation(null, UVM_SETOBJ, str__); \
                  __m_uvm_status_container.scope.up(); \
                end \
              end \
            end \
          end \
        end \
        end \
    endcase \
  end 



`define uvm_field_array_string(ARG,FLAG) \
  `M_UVM_FIELD_QDA_STRING(ARRAY,ARG,FLAG)

`define M_UVM_FIELD_QDA_STRING(TYPE,ARG,FLAG) \
  begin \
    case (what__) \
      UVM_CHECK_FIELDS: \
        __m_uvm_status_container.do_field_check(`"ARG`", this); \
      UVM_COPY: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOPY)) ARG = local_data__.ARG; \
        end \
      UVM_COMPARE: \
        begin \
          if(local_data__ == null) return; \
          if(!((FLAG)&UVM_NOCOMPARE)) begin \
            if(ARG != local_data__.ARG) begin \
               if(__m_uvm_status_container.comparer.show_max == 1) begin \
                 __m_uvm_status_container.scope.set_arg(`"ARG`"); \
                 __m_uvm_status_container.comparer.print_msg(""); \
               end \
               else if(__m_uvm_status_container.comparer.show_max) begin \
                 if(ARG.size() != local_data__.ARG.size()) begin \
                   void'(__m_uvm_status_container.comparer.compare_field(`"ARG``.size`", ARG.size(), local_data__.ARG.size(), 32)); \
                 end \
                 else begin \
                   foreach(ARG[i]) begin \
                     if(ARG[i] != local_data__.ARG[i]) begin \
                       __m_uvm_status_container.scope.set_arg_element(`"ARG`",i); \
                       void'(__m_uvm_status_container.comparer.compare_string("", ARG[i], local_data__.ARG[i])); \
                     end \
                   end \
                 end \
               end \
               else if ((__m_uvm_status_container.comparer.physical&&((FLAG)&UVM_PHYSICAL)) || \
                        (__m_uvm_status_container.comparer.abstract&&((FLAG)&UVM_ABSTRACT)) || \
                        (!((FLAG)&UVM_PHYSICAL) && !((FLAG)&UVM_ABSTRACT)) ) \
                 __m_uvm_status_container.comparer.result++; \
               if(__m_uvm_status_container.comparer.result && (__m_uvm_status_container.comparer.show_max <= __m_uvm_status_container.comparer.result)) return; \
            end \
          end \
        end \
      UVM_PACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          if(__m_uvm_status_container.packer.use_metadata) __m_uvm_status_container.packer.pack_field_int(ARG.size(), 32); \
          foreach(ARG[i])  \
            __m_uvm_status_container.packer.pack_string(ARG[i]); \
        end \
      UVM_UNPACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          int sz = ARG.size(); \
          if(__m_uvm_status_container.packer.use_metadata) sz = __m_uvm_status_container.packer.unpack_field_int(32); \
          if(sz != ARG.size()) begin \
            `M_UVM_``TYPE``_RESIZE(ARG,"") \
          end \
          foreach(ARG[i]) \
            ARG[i] = __m_uvm_status_container.packer.unpack_string(); \
        end \
      UVM_RECORD: \
        `m_uvm_record_qda_string(ARG,FLAG,ARG.size()) \
      UVM_PRINT: \
        begin \
          if(((FLAG)&UVM_NOPRINT) == 0) begin \
             `uvm_print_array_string2(ARG, __m_uvm_status_container.printer) \
          end \
        end \
      UVM_SETINT: \
        begin \
          __m_uvm_status_container.scope.set_arg(`"ARG`"); \
          if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
            if((FLAG)&UVM_READONLY) begin \
              uvm_report_warning("RDONLY", $sformatf("Readonly argument match %s is ignored",  \
                 __m_uvm_status_container.get_full_scope_arg()), UVM_NONE); \
            end \
            else begin \
              int sz =  uvm_object::__m_uvm_status_container.bitstream; \
              if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
              if(ARG.size() !=  sz) begin \
                `M_UVM_``TYPE``_RESIZE(ARG,"") \
              end \
              __m_uvm_status_container.status = 1; \
            end \
          end \
        end \
      UVM_SETSTR: \
        begin \
          if(!((FLAG)&UVM_READONLY)) begin \
            bit wildcard_index__; \
            int index__; \
            __m_uvm_status_container.scope.set_arg(`"ARG`"); \
            index__ = uvm_get_array_index_int(str__, wildcard_index__); \
            if(uvm_is_array(str__)  && (index__ != -1)) begin\
              if(wildcard_index__) begin \
                for(index__=0; index__<ARG.size(); ++index__) begin \
                  if(uvm_is_match(str__, {__m_uvm_status_container.scope.get_arg(),$sformatf("[%0d]", index__)})) begin \
                    if (__m_uvm_status_container.print_matches) \
                      uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg(), $sformatf("[%0d]",index__)}, UVM_LOW); \
                    ARG[index__] = uvm_object::__m_uvm_status_container.stringv; \
                    __m_uvm_status_container.status = 1; \
                  end \
                end \
              end \
              else if(uvm_is_match(str__, {__m_uvm_status_container.scope.get_arg(),$sformatf("[%0d]", index__)})) begin \
                if(index__+1 > ARG.size()) begin \
                  int sz = index__; \
                  string tmp__; \
                  `M_UVM_``TYPE``_RESIZE(ARG,tmp__) \
                end \
                if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
                ARG[index__] =  uvm_object::__m_uvm_status_container.stringv; \
                __m_uvm_status_container.status = 1; \
              end \
            end \
          end \
        end \
    endcase \
  end




`define uvm_field_array_enum(T,ARG,FLAG) \
  `M_FIELD_QDA_ENUM(ARRAY,T,ARG,FLAG) 

`define M_FIELD_QDA_ENUM(TYPE,T,ARG,FLAG) \
  begin \
    case (what__) \
      UVM_CHECK_FIELDS: \
        __m_uvm_status_container.do_field_check(`"ARG`", this); \
      UVM_COPY: \
        begin \
          if(!((FLAG)&UVM_NOCOPY)) ARG = local_data__.ARG; \
        end \
      UVM_COMPARE: \
        begin \
          if(!((FLAG)&UVM_NOCOMPARE)) begin \
            if(ARG !== local_data__.ARG) begin \
               if(__m_uvm_status_container.comparer.show_max == 1) begin \
                 __m_uvm_status_container.scope.set_arg(`"ARG`"); \
                 __m_uvm_status_container.comparer.print_msg(""); \
               end \
               else if(__m_uvm_status_container.comparer.show_max) begin \
                 if(ARG.size() != local_data__.ARG.size()) begin \
                   void'(__m_uvm_status_container.comparer.compare_field(`"ARG``.size`", ARG.size(), local_data__.ARG.size(), 32)); \
                 end \
                 else begin \
                   foreach(ARG[i]) begin \
                     if(ARG[i] !== local_data__.ARG[i]) begin \
                       __m_uvm_status_container.scope.set_arg_element(`"ARG`",i); \
                       $swrite(__m_uvm_status_container.stringv, "lhs = %0s : rhs = %0s", \
                         ARG[i].name(), local_data__.ARG[i].name()); \
                       __m_uvm_status_container.comparer.print_msg(__m_uvm_status_container.stringv); \
                       if(__m_uvm_status_container.comparer.result && (__m_uvm_status_container.comparer.show_max <= __m_uvm_status_container.comparer.result)) return; \
                     end \
                   end \
                 end \
               end \
               else if ((__m_uvm_status_container.comparer.physical&&((FLAG)&UVM_PHYSICAL)) || \
                        (__m_uvm_status_container.comparer.abstract&&((FLAG)&UVM_ABSTRACT)) || \
                        (!((FLAG)&UVM_PHYSICAL) && !((FLAG)&UVM_ABSTRACT)) ) \
                 __m_uvm_status_container.comparer.result++; \
               if(__m_uvm_status_container.comparer.result && (__m_uvm_status_container.comparer.show_max <= __m_uvm_status_container.comparer.result)) return; \
            end \
          end \
        end \
      UVM_PACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          if(__m_uvm_status_container.packer.use_metadata) __m_uvm_status_container.packer.pack_field_int(ARG.size(), 32); \
          foreach(ARG[i])  \
            __m_uvm_status_container.packer.pack_field_int(int'(ARG[i]), $bits(ARG[i])); \
        end \
      UVM_UNPACK: \
        if(!((FLAG)&UVM_NOPACK)) begin \
          int sz = ARG.size(); \
          if(__m_uvm_status_container.packer.use_metadata) sz = __m_uvm_status_container.packer.unpack_field_int(32); \
          if(sz != ARG.size()) begin \
            T tmp__; \
            `M_UVM_``TYPE``_RESIZE(ARG,tmp__) \
          end \
          foreach(ARG[i]) \
            ARG[i] = T'(__m_uvm_status_container.packer.unpack_field_int($bits(ARG[i]))); \
        end \
      UVM_RECORD: \
        `m_uvm_record_qda_enum(ARG,FLAG,ARG.size()) \
      UVM_PRINT: \
        begin \
          if(((FLAG)&UVM_NOPRINT) == 0) begin \
             `uvm_print_qda_enum(ARG, __m_uvm_status_container.printer, array, T) \
          end \
        end \
      UVM_SETINT: \
        begin \
          __m_uvm_status_container.scope.set_arg(`"ARG`"); \
          if(uvm_is_match(str__, __m_uvm_status_container.scope.get())) begin \
            if((FLAG)&UVM_READONLY) begin \
              uvm_report_warning("RDONLY", $sformatf("Readonly argument match %s is ignored",  \
                 __m_uvm_status_container.get_full_scope_arg()), UVM_NONE); \
            end \
            else begin \
              int sz =  uvm_object::__m_uvm_status_container.bitstream; \
              if (__m_uvm_status_container.print_matches) \
              uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
              if(ARG.size() !=  sz) begin \
                T tmp__; \
                `M_UVM_``TYPE``_RESIZE(ARG,tmp__) \
              end \
              __m_uvm_status_container.status = 1; \
            end \
          end \
          else if(!((FLAG)&UVM_READONLY)) begin \
            bit wildcard_index__; \
            int index__; \
            index__ = uvm_get_array_index_int(str__, wildcard_index__); \
            if(uvm_is_array(str__)  && (index__ != -1)) begin\
              if(wildcard_index__) begin \
                for(index__=0; index__<ARG.size(); ++index__) begin \
                  if(uvm_is_match(str__, {__m_uvm_status_container.scope.get_arg(),$sformatf("[%0d]", index__)})) begin \
                    if (__m_uvm_status_container.print_matches) \
                      uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg(), $sformatf("[%0d]",index__)}, UVM_LOW); \
                    ARG[index__] = T'(uvm_object::__m_uvm_status_container.bitstream); \
                    __m_uvm_status_container.status = 1; \
                  end \
                end \
              end \
              else if(uvm_is_match(str__, {__m_uvm_status_container.scope.get_arg(),$sformatf("[%0d]", index__)})) begin \
                if(index__+1 > ARG.size()) begin \
                  int sz = index__; \
                  T tmp__; \
                  `M_UVM_``TYPE``_RESIZE(ARG,tmp__) \
                end \
                if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
                ARG[index__] =  T'(uvm_object::__m_uvm_status_container.bitstream); \
                __m_uvm_status_container.status = 1; \
              end \
            end \
          end \
        end \
      UVM_SETSTR: \
        begin \
          if(!((FLAG)&UVM_READONLY)) begin \
            bit wildcard_index__; \
            int index__; \
            __m_uvm_status_container.scope.set_arg(`"ARG`"); \
            index__ = uvm_get_array_index_int(str__, wildcard_index__); \
            if(uvm_is_array(str__)  && (index__ != -1)) begin\
              if(wildcard_index__) begin \
                for(index__=0; index__<ARG.size(); ++index__) begin \
                  if(uvm_is_match(str__, {__m_uvm_status_container.scope.get_arg(),$sformatf("[%0d]", index__)})) begin \
	                  T t__; \
                    if (__m_uvm_status_container.print_matches) \
                      uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg(), $sformatf("[%0d]",index__)}, UVM_LOW); \
                    void'(uvm_enum_wrapper#(T)::from_name(uvm_object::__m_uvm_status_container.stringv, t__)); ARG[index__]=t__; \
                    __m_uvm_status_container.status = 1; \
                  end \
                end \
              end \
              else if(uvm_is_match(str__, {__m_uvm_status_container.scope.get_arg(),$sformatf("[%0d]", index__)})) begin \
	            T t__; \
                if(index__+1 > ARG.size()) begin \
                  int sz = index__; \
                  T tmp__; \
                  `M_UVM_``TYPE``_RESIZE(ARG,tmp__) \
                end \
                if (__m_uvm_status_container.print_matches) \
                  uvm_report_info("STRMTC", {"set_int()", ": Matched string ", str__, " to field ", __m_uvm_status_container.get_full_scope_arg()}, UVM_LOW); \
                void'(uvm_enum_wrapper#(T)::from_name(uvm_object::__m_uvm_status_container.stringv, t__)); ARG[index__]=t__; \
                __m_uvm_status_container.status = 1; \
              end \
            end \
          end \
        end \
    endcase \
  end




`define uvm_field_queue_int(ARG,FLAG) \
  `M_UVM_FIELD_QDA_INT(QUEUE,ARG,FLAG)


`define uvm_field_queue_object(ARG,FLAG) \
  `M_UVM_FIELD_QDA_OBJECT(QUEUE,ARG,FLAG)



`define uvm_field_queue_string(ARG,FLAG) \
  `M_UVM_FIELD_QDA_STRING(QUEUE,ARG,FLAG)



`define uvm_field_queue_enum(T,ARG,FLAG) \
  `M_FIELD_QDA_ENUM(QUEUE,T,ARG,FLAG)




`define uvm_field_aa_int_string(ARG, FLAG) \
  begin \
  if(what__==UVM_CHECK_FIELDS) __m_uvm_status_container.do_field_check(`"ARG`", this); \
  `M_UVM_FIELD_DATA_AA_int_string(ARG,FLAG) \
  `M_UVM_FIELD_SET_AA_TYPE(string, INT, ARG, __m_uvm_status_container.bitstream, FLAG)  \
  end



`define uvm_field_aa_object_string(ARG, FLAG) \
  begin \
  if(what__==UVM_CHECK_FIELDS) __m_uvm_status_container.do_field_check(`"ARG`", this); \
  `M_UVM_FIELD_DATA_AA_object_string(ARG,FLAG) \
  `M_UVM_FIELD_SET_AA_OBJECT_TYPE(string, ARG, FLAG)  \
  end



`define uvm_field_aa_string_string(ARG, FLAG) \
  begin \
  if(what__==UVM_CHECK_FIELDS) __m_uvm_status_container.do_field_check(`"ARG`", this); \
  `M_UVM_FIELD_DATA_AA_string_string(ARG,FLAG) \
  `M_UVM_FIELD_SET_AA_TYPE(string, STR, ARG, __m_uvm_status_container.stringv, FLAG)  \
  end




`define uvm_field_aa_object_int(ARG, FLAG) \
  begin \
  if(what__==UVM_CHECK_FIELDS) __m_uvm_status_container.do_field_check(`"ARG`", this); \
  `M_UVM_FIELD_DATA_AA_object_int(ARG,FLAG) \
  `M_UVM_FIELD_SET_AA_OBJECT_TYPE(int, ARG, FLAG)  \
  end



`define uvm_field_aa_int_int(ARG, FLAG) \
  `uvm_field_aa_int_key(int, ARG, FLAG) \



`define uvm_field_aa_int_int_unsigned(ARG, FLAG) \
  `uvm_field_aa_int_key(int unsigned, ARG, FLAG)



`define uvm_field_aa_int_integer(ARG, FLAG) \
  `uvm_field_aa_int_key(integer, ARG, FLAG)



`define uvm_field_aa_int_integer_unsigned(ARG, FLAG) \
  `uvm_field_aa_int_key(integer unsigned, ARG, FLAG)



`define uvm_field_aa_int_byte(ARG, FLAG) \
  `uvm_field_aa_int_key(byte, ARG, FLAG)



`define uvm_field_aa_int_byte_unsigned(ARG, FLAG) \
  `uvm_field_aa_int_key(byte unsigned, ARG, FLAG)



`define uvm_field_aa_int_shortint(ARG, FLAG) \
  `uvm_field_aa_int_key(shortint, ARG, FLAG)



`define uvm_field_aa_int_shortint_unsigned(ARG, FLAG) \
  `uvm_field_aa_int_key(shortint unsigned, ARG, FLAG)



`define uvm_field_aa_int_longint(ARG, FLAG) \
  `uvm_field_aa_int_key(longint, ARG, FLAG)



`define uvm_field_aa_int_longint_unsigned(ARG, FLAG) \
  `uvm_field_aa_int_key(longint unsigned, ARG, FLAG)



`define uvm_field_aa_int_key(KEY, ARG, FLAG) \
  begin \
  if(what__==UVM_CHECK_FIELDS) __m_uvm_status_container.do_field_check(`"ARG`", this); \
  `M_UVM_FIELD_DATA_AA_int_key(KEY,ARG,FLAG) \
  `M_UVM_FIELD_SET_AA_INT_TYPE(KEY, INT, ARG, __m_uvm_status_container.bitstream, FLAG)  \
  end



`define uvm_field_aa_int_enumkey(KEY, ARG, FLAG) \
  begin \
  if(what__==UVM_CHECK_FIELDS) __m_uvm_status_container.do_field_check(`"ARG`", this); \
  `M_UVM_FIELD_DATA_AA_enum_key(KEY,ARG,FLAG) \
  `M_UVM_FIELD_SET_AA_INT_ENUMTYPE(KEY, INT, ARG, __m_uvm_status_container.bitstream, FLAG)  \
  end



`define m_uvm_print_int(ARG,FLAG) \
  if(!((FLAG)&UVM_NOPRINT)) begin \
     if ($bits(ARG) > 64) \
      __m_uvm_status_container.printer.print_field(`"ARG`", ARG,  $bits(ARG), uvm_radix_enum'((FLAG)&(UVM_RADIX))); \
     else \
      __m_uvm_status_container.printer.print_field_int(`"ARG`", ARG,  $bits(ARG), uvm_radix_enum'((FLAG)&(UVM_RADIX))); \
  end




`define m_uvm_record_int(ARG,FLAG) \
  if(!((FLAG)&UVM_NORECORD)) begin \
    if ($bits(ARG) > 64) \
      __m_uvm_status_container.recorder.record_field(`"ARG`", ARG,  $bits(ARG), uvm_radix_enum'((FLAG)&(UVM_RADIX))); \
    else \
      __m_uvm_status_container.recorder.record_field_int(`"ARG`", ARG,  $bits(ARG), uvm_radix_enum'((FLAG)&(UVM_RADIX))); \
  end



      

`define m_uvm_record_string(ARG,STR,FLAG) \
  if(!((FLAG)&UVM_NORECORD)) begin \
    __m_uvm_status_container.recorder.record_string(`"ARG`", STR); \
  end





`define m_uvm_record_object(ARG,FLAG) \
  if(!((FLAG)&UVM_NORECORD)) begin \
    __m_uvm_status_container.recorder.record_object(`"ARG`", ARG); \
  end



`define m_uvm_record_qda_int(ARG, FLAG, SZ) \
  begin \
    if(!((FLAG)&UVM_NORECORD)) begin \
      int sz__ = SZ; \
      if(sz__ == 0) begin \
        __m_uvm_status_container.recorder.record_field_int(`"ARG`", 0, 32, UVM_DEC); \
      end \
      else if(sz__ < 10) begin \
        foreach(ARG[i]) begin \
           __m_uvm_status_container.scope.set_arg_element(`"ARG`",i); \
           if ($bits(ARG[i]) > 64) \
             __m_uvm_status_container.recorder.record_field(__m_uvm_status_container.scope.get(), ARG[i], $bits(ARG[i]), uvm_radix_enum'((FLAG)&UVM_RADIX)); \
           else \
             __m_uvm_status_container.recorder.record_field_int(__m_uvm_status_container.scope.get(), ARG[i], $bits(ARG[i]), uvm_radix_enum'((FLAG)&UVM_RADIX)); \
        end \
      end \
      else begin \
        for(int i=0; i<5; ++i) begin \
           __m_uvm_status_container.scope.set_arg_element(`"ARG`", i); \
           if ($bits(ARG[i]) > 64) \
             __m_uvm_status_container.recorder.record_field(__m_uvm_status_container.scope.get(), ARG[i], $bits(ARG[i]), uvm_radix_enum'((FLAG)&UVM_RADIX)); \
           else \
             __m_uvm_status_container.recorder.record_field_int(__m_uvm_status_container.scope.get(), ARG[i], $bits(ARG[i]), uvm_radix_enum'((FLAG)&UVM_RADIX)); \
        end \
        for(int i=sz__-5; i<sz__; ++i) begin \
           __m_uvm_status_container.scope.set_arg_element(`"ARG`", i); \
           if ($bits(ARG[i]) > 64) \
             __m_uvm_status_container.recorder.record_field(__m_uvm_status_container.scope.get(), ARG[i], $bits(ARG[i]), uvm_radix_enum'((FLAG)&UVM_RADIX)); \
           else \
             __m_uvm_status_container.recorder.record_field_int(__m_uvm_status_container.scope.get(), ARG[i], $bits(ARG[i]), uvm_radix_enum'((FLAG)&UVM_RADIX)); \
        end \
      end \
    end \
  end



`define m_uvm_record_qda_enum(ARG, FLAG, SZ) \
  begin \
    if(!((FLAG)&UVM_NORECORD) && (__m_uvm_status_container.recorder != null)) begin \
      int sz__ = SZ; \
      if(sz__ == 0) begin \
        __m_uvm_status_container.recorder.record_field_int(`"ARG``.size`", 0, 32, UVM_DEC); \
      end \
      else if(sz__ < 10) begin \
        foreach(ARG[i]) begin \
           __m_uvm_status_container.scope.set_arg_element(`"ARG`",i); \
           __m_uvm_status_container.recorder.record_string(__m_uvm_status_container.scope.get(), ARG[i].name()); \
        end \
      end \
      else begin \
        for(int i=0; i<5; ++i) begin \
           __m_uvm_status_container.scope.set_arg_element(`"ARG`", i); \
           __m_uvm_status_container.recorder.record_string(__m_uvm_status_container.scope.get(), ARG[i].name()); \
        end \
        for(int i=sz__-5; i<sz__; ++i) begin \
           __m_uvm_status_container.scope.set_arg_element(`"ARG`", i); \
           __m_uvm_status_container.recorder.record_string(__m_uvm_status_container.scope.get(), ARG[i].name()); \
        end \
      end \
    end \
  end



`define m_uvm_record_qda_object(ARG, FLAG, SZ) \
  begin \
    if(!((FLAG)&UVM_NORECORD)) begin \
      int sz__ = SZ; \
      string s; \
      if(sz__ == 0 ) begin \
        __m_uvm_status_container.recorder.record_field_int(`"ARG``.size`", 0, 32, UVM_DEC); \
      end \
      if(sz__ < 10) begin \
        foreach(ARG[i]) begin \
           $swrite(s,`"ARG[%0d]`", i); \
           __m_uvm_status_container.recorder.record_object(s, ARG[i]); \
        end \
      end \
      else begin \
        for(int i=0; i<5; ++i) begin \
           $swrite(s,`"ARG[%0d]`", i); \
           __m_uvm_status_container.recorder.record_object(s, ARG[i]); \
        end \
        for(int i=sz__-5; i<sz__; ++i) begin \
           $swrite(s,`"ARG[%0d]`", i); \
           __m_uvm_status_container.recorder.record_object(s, ARG[i]); \
        end \
      end \
    end \
  end



`define m_uvm_record_qda_string(ARG, FLAG, SZ) \
  begin \
    int sz__ = SZ; \
    if(!((FLAG)&UVM_NORECORD)) begin \
      if(sz__ == 0) begin \
        __m_uvm_status_container.recorder.record_field_int(`"ARG``.size`", 0, 32, UVM_DEC); \
      end \
      else if(sz__ < 10) begin \
        foreach(ARG[i]) begin \
           __m_uvm_status_container.scope.set_arg_element(`"ARG`",i); \
           __m_uvm_status_container.recorder.record_string(__m_uvm_status_container.scope.get(), ARG[i]); \
        end \
      end \
      else begin \
        for(int i=0; i<5; ++i) begin \
           __m_uvm_status_container.scope.set_arg_element(`"ARG`", i); \
           __m_uvm_status_container.recorder.record_string(__m_uvm_status_container.scope.get(), ARG[i]); \
        end \
        for(int i=sz__-5; i<sz__; ++i) begin \
           __m_uvm_status_container.scope.set_arg_element(`"ARG`", i); \
           __m_uvm_status_container.recorder.record_string(__m_uvm_status_container.scope.get(), ARG[i]); \
        end \
      end \
    end \
  end



`define M_UVM_FIELD_DATA_AA_generic(TYPE, KEY, ARG, FLAG) \
  begin \
    begin \
      case (what__) \
        UVM_COMPARE: \
           begin \
            if(!((FLAG)&UVM_NOCOMPARE) && (tmp_data__ != null) ) \
            begin \
              $cast(local_data__, tmp_data__); \
              if(ARG.num() != local_data__.ARG.num()) begin \
                 int s1__, s2__; \
                 __m_uvm_status_container.stringv = ""; \
                 s1__ = ARG.num(); s2__ = local_data__.ARG.num(); \
                 $swrite(__m_uvm_status_container.stringv, "lhs size = %0d : rhs size = %0d", \
                    s1__, s2__);\
                 __m_uvm_status_container.comparer.print_msg(__m_uvm_status_container.stringv); \
              end \
              string_aa_key = ""; \
              while(ARG.next(string_aa_key)) begin \
                string s; \
                __m_uvm_status_container.scope.set_arg({"[",string_aa_key,"]"}); \
                s = {`"ARG[`",string_aa_key,"]"}; \
                if($bits(ARG[string_aa_key]) <= 64) \
                  void'(__m_uvm_status_container.comparer.compare_field_int(s, ARG[string_aa_key], local_data__.ARG[string_aa_key], $bits(ARG[string_aa_key]), uvm_radix_enum'((FLAG)&UVM_RADIX))); \
                else \
                  void'(__m_uvm_status_container.comparer.compare_field(s, ARG[string_aa_key], local_data__.ARG[string_aa_key], $bits(ARG[string_aa_key]), uvm_radix_enum'((FLAG)&UVM_RADIX))); \
                __m_uvm_status_container.scope.unset_arg(string_aa_key); \
              end \
            end \
           end \
        UVM_COPY: \
          begin \
            if(!((FLAG)&UVM_NOCOPY) && (tmp_data__ != null) ) \
            begin \
              $cast(local_data__, tmp_data__); \
              ARG.delete(); \
              string_aa_key = ""; \
              while(local_data__.ARG.next(string_aa_key)) \
                ARG[string_aa_key] = local_data__.ARG[string_aa_key]; \
            end \
          end \
        UVM_PRINT: \
          if(!((FLAG)&UVM_NOPRINT)) begin \
            `uvm_print_aa_``KEY``_``TYPE``3(ARG, uvm_radix_enum'((FLAG)&(UVM_RADIX)), \
                                            __m_uvm_status_container.printer) \
          end \
      endcase \
    end \
  end



`define M_UVM_FIELD_DATA_AA_int_string(ARG, FLAG) \
  `M_UVM_FIELD_DATA_AA_generic(int, string, ARG, FLAG)



`define M_UVM_FIELD_DATA_AA_int_key(KEY, ARG, FLAG) \
  begin \
    begin \
      KEY aa_key; \
      case (what__) \
        UVM_COMPARE: \
           begin \
            if(!((FLAG)&UVM_NOCOMPARE) && (tmp_data__ != null) ) \
            begin \
              $cast(local_data__, tmp_data__); \
              if(ARG.num() != local_data__.ARG.num()) begin \
                 int s1__, s2__; \
                 __m_uvm_status_container.stringv = ""; \
                 s1__ = ARG.num(); s2__ = local_data__.ARG.num(); \
                 $swrite(__m_uvm_status_container.stringv, "lhs size = %0d : rhs size = %0d", \
                    s1__, s2__);\
                 __m_uvm_status_container.comparer.print_msg(__m_uvm_status_container.stringv); \
              end \
              foreach(ARG[_aa_key]) begin \
                  string s; \
                  $swrite(string_aa_key, "%0d", _aa_key); \
                  __m_uvm_status_container.scope.set_arg({"[",string_aa_key,"]"}); \
                  s = {`"ARG[`",string_aa_key,"]"}; \
                  if($bits(ARG[_aa_key]) <= 64) \
                    void'(__m_uvm_status_container.comparer.compare_field_int(s, ARG[_aa_key], local_data__.ARG[_aa_key], $bits(ARG[_aa_key]), uvm_radix_enum'((FLAG)&UVM_RADIX))); \
                  else \
                    void'(__m_uvm_status_container.comparer.compare_field(s, ARG[_aa_key], local_data__.ARG[_aa_key], $bits(ARG[_aa_key]), uvm_radix_enum'((FLAG)&UVM_RADIX))); \
                  __m_uvm_status_container.scope.unset_arg(string_aa_key); \
                end \
            end \
           end \
        UVM_COPY: \
          begin \
            if(!((FLAG)&UVM_NOCOPY) && (tmp_data__ != null) ) \
            begin \
              $cast(local_data__, tmp_data__); \
              ARG.delete(); \
              if(local_data__.ARG.first(aa_key)) \
                do begin \
                  ARG[aa_key] = local_data__.ARG[aa_key]; \
                end while(local_data__.ARG.next(aa_key)); \
            end \
          end \
        UVM_PRINT: \
          if(!((FLAG)&UVM_NOPRINT)) begin \
             `uvm_print_aa_int_key4(KEY,ARG, uvm_radix_enum'((FLAG)&(UVM_RADIX)), \
                                    __m_uvm_status_container.printer) \
          end \
      endcase \
    end \
  end



`define M_UVM_FIELD_DATA_AA_enum_key(KEY, ARG, FLAG) \
  begin \
    begin \
      KEY aa_key; \
      case (what__) \
        UVM_COMPARE: \
           begin \
            if(!((FLAG)&UVM_NOCOMPARE) && (tmp_data__ != null) ) \
            begin \
              $cast(local_data__, tmp_data__); \
              if(ARG.num() != local_data__.ARG.num()) begin \
                 int s1__, s2__; \
                 __m_uvm_status_container.stringv = ""; \
                 s1__ = ARG.num(); s2__ = local_data__.ARG.num(); \
                 $swrite(__m_uvm_status_container.stringv, "lhs size = %0d : rhs size = %0d", \
                    s1__, s2__);\
                 __m_uvm_status_container.comparer.print_msg(__m_uvm_status_container.stringv); \
              end \
              foreach(ARG[_aa_key]) begin \
                  void'(__m_uvm_status_container.comparer.compare_field_int({`"ARG[`",_aa_key.name(),"]"}, \
                    ARG[_aa_key], local_data__.ARG[_aa_key], $bits(ARG[_aa_key]), \
                    uvm_radix_enum'((FLAG)&UVM_RADIX) )); \
                end \
            end \
           end \
        UVM_COPY: \
          begin \
            if(!((FLAG)&UVM_NOCOPY) && (tmp_data__ != null) ) \
            begin \
              $cast(local_data__, tmp_data__); \
              ARG=local_data__.ARG; \
            end \
          end \
        UVM_PRINT: \
          if(!((FLAG)&UVM_NOPRINT)) begin \
            uvm_printer p__ = __m_uvm_status_container.printer; \
            p__.print_array_header (`"ARG`", ARG.num(),`"aa_``KEY`"); \
            if((p__.knobs.depth == -1) || (__m_uvm_status_container.printer.m_scope.depth() < p__.knobs.depth+1)) \
            begin \
              foreach(ARG[_aa_key]) \
               begin \
                  if ($bits(ARG[_aa_key]) > 64) \
                    __m_uvm_status_container.printer.print_field( \
                      {"[",_aa_key.name(),"]"}, ARG[_aa_key], $bits(ARG[_aa_key]), \
                      uvm_radix_enum'((FLAG)&UVM_RADIX), "[" ); \
                  else \
                    __m_uvm_status_container.printer.print_field_int( \
                      {"[",_aa_key.name(),"]"}, ARG[_aa_key], $bits(ARG[_aa_key]), \
                      uvm_radix_enum'((FLAG)&UVM_RADIX), "[" ); \
                end \
            end \
            p__.print_array_footer(ARG.num()); \
          end \
      endcase \
    end \
  end 



`define M_UVM_FIELD_DATA_AA_object_string(ARG, FLAG) \
  begin \
    begin \
      case (what__) \
        UVM_COMPARE: \
           begin \
            if(!((FLAG)&UVM_NOCOMPARE) && (tmp_data__ != null) ) \
            begin \
              $cast(local_data__, tmp_data__); \
              if(ARG.num() != local_data__.ARG.num()) begin \
                 int s1__, s2__; \
                 __m_uvm_status_container.stringv = ""; \
                 s1__ = ARG.num(); s2__ = local_data__.ARG.num(); \
                 $swrite(__m_uvm_status_container.stringv, "lhs size = %0d : rhs size = %0d", \
                          s1__, s2__);\
                 __m_uvm_status_container.comparer.print_msg(__m_uvm_status_container.stringv); \
              end \
              string_aa_key = ""; \
              while(ARG.next(string_aa_key)) begin \
                uvm_object lhs; \
                uvm_object rhs; \
                lhs = ARG[string_aa_key]; \
                rhs = local_data__.ARG[string_aa_key]; \
                __m_uvm_status_container.scope.down({"[",string_aa_key,"]"}); \
                if(rhs != lhs) begin \
                  bit refcmp; \
                  refcmp = ((FLAG)& UVM_SHALLOW) && !(__m_uvm_status_container.comparer.policy == UVM_DEEP); \
                  if(!refcmp && !(__m_uvm_status_container.comparer.policy == UVM_REFERENCE)) begin \
                    if(((rhs == null) && (lhs != null)) || ((lhs==null) && (rhs!=null))) begin \
                      __m_uvm_status_container.comparer.print_msg_object(lhs, rhs); \
                    end \
                    else begin \
                      if (lhs != null)  \
                        void'(lhs.compare(rhs, __m_uvm_status_container.comparer)); \
                    end \
                  end \
                  else begin  \
                    __m_uvm_status_container.comparer.print_msg_object(lhs, rhs); \
                  end \
                end \
                __m_uvm_status_container.scope.up_element(); \
              end \
            end \
          end \
        UVM_COPY: \
          begin \
           if(!((FLAG)&UVM_NOCOPY) && (tmp_data__ != null) ) \
           begin \
            $cast(local_data__, tmp_data__); \
            ARG.delete(); \
            foreach(local_data__.ARG[_string_aa_key]) begin\
               if((FLAG)&UVM_REFERENCE) \
                ARG[_string_aa_key] = local_data__.ARG[_string_aa_key]; \
               else begin\
                $cast(ARG[_string_aa_key],local_data__.ARG[_string_aa_key].clone());\
                ARG[_string_aa_key].set_name({`"ARG`","[",_string_aa_key, "]"});\
               end \
             end \
           end \
          end \
        UVM_PRINT: \
          if(!((FLAG)&UVM_NOPRINT)) begin \
            `uvm_print_aa_string_object3(ARG, __m_uvm_status_container.printer,FLAG) \
          end \
      endcase \
    end \
  end



`define M_UVM_FIELD_DATA_AA_object_int(ARG, FLAG) \
  begin \
    int key__; \
    begin \
      case (what__) \
        UVM_COMPARE: \
           begin \
            if(!((FLAG)&UVM_NOCOMPARE) && (tmp_data__ != null) ) \
            begin \
              $cast(local_data__, tmp_data__); \
              if(ARG.num() != local_data__.ARG.num()) begin \
                 int s1__, s2__; \
                 __m_uvm_status_container.stringv = ""; \
                 s1__ = ARG.num(); s2__ = local_data__.ARG.num(); \
                 $swrite(__m_uvm_status_container.stringv, "lhs size = %0d : rhs size = %0d", \
                          s1__, s2__);\
                 __m_uvm_status_container.comparer.print_msg(__m_uvm_status_container.stringv); \
              end \
              foreach(ARG[_key__]) begin \
                  uvm_object lhs; \
                  uvm_object rhs; \
                  lhs = ARG[key__]; \
                  rhs = local_data__.ARG[_key__]; \
                  __m_uvm_status_container.scope.down_element(_key__); \
                  if(rhs != lhs) begin \
                    bit refcmp; \
                    refcmp = ((FLAG)& UVM_SHALLOW) && !(__m_uvm_status_container.comparer.policy == UVM_DEEP); \
                    if(!refcmp && !(__m_uvm_status_container.comparer.policy == UVM_REFERENCE)) begin \
                      if(((rhs == null) && (lhs != null)) || ((lhs==null) && (rhs!=null))) begin \
                        __m_uvm_status_container.comparer.print_msg_object(lhs, rhs); \
                      end \
                      else begin \
                        if (lhs != null)  \
                          void'(lhs.compare(rhs, __m_uvm_status_container.comparer)); \
                      end \
                    end \
                    else begin  \
                      __m_uvm_status_container.comparer.print_msg_object(lhs, rhs); \
                    end \
                  end \
                  __m_uvm_status_container.scope.up_element(); \
              end \
            end \
          end \
        UVM_COPY: \
          begin \
           if(!((FLAG)&UVM_NOCOPY) && (tmp_data__ != null) ) \
           begin \
            $cast(local_data__, tmp_data__); \
            ARG.delete(); \
            foreach(local_data__.ARG[_key__]) begin \
               if((FLAG)&UVM_REFERENCE) \
                ARG[_key__] = local_data__.ARG[_key__]; \
               else begin\
                 uvm_object tmp_obj; \
                 tmp_obj = local_data__.ARG[_key__].clone(); \
                 if(tmp_obj != null) \
                   $cast(ARG[_key__], tmp_obj); \
                 else \
                   ARG[_key__]=null; \
               end \
             end \
           end \
         end \
        UVM_PRINT: \
          if(!((FLAG)&UVM_NOPRINT)) begin \
             `uvm_print_aa_int_object3(ARG, __m_uvm_status_container.printer,FLAG) \
          end \
      endcase \
    end \
  end



`define M_UVM_FIELD_DATA_AA_string_string(ARG, FLAG) \
  begin \
    begin \
      case (what__) \
        UVM_COPY: \
          begin \
            if(!((FLAG)&UVM_NOCOPY) && (local_data__ !=null)) \
              ARG = local_data__.ARG ; \
          end \
        UVM_PRINT: \
          if(!((FLAG)&UVM_NOPRINT)) begin \
            `uvm_print_aa_string_string2(ARG, __m_uvm_status_container.printer) \
          end \
        UVM_COMPARE: \
           begin \
            if(!((FLAG)&UVM_NOCOMPARE) && (tmp_data__ != null) ) \
            begin \
              $cast(local_data__, tmp_data__); \
              if(ARG.num() != local_data__.ARG.num()) begin \
                 int s1__, s2__; \
                 __m_uvm_status_container.stringv = ""; \
                 s1__ = ARG.num(); s2__ = local_data__.ARG.num(); \
                 $swrite(__m_uvm_status_container.stringv, "lhs size = %0d : rhs size = %0d", \
                    s1__, s2__);\
                 __m_uvm_status_container.comparer.print_msg(__m_uvm_status_container.stringv); \
              end \
              string_aa_key = ""; \
              while(ARG.next(string_aa_key)) begin \
                string s__ = ARG[string_aa_key]; \
                __m_uvm_status_container.scope.set_arg({"[",string_aa_key,"]"}); \
                if(ARG[string_aa_key] != local_data__.ARG[string_aa_key]) begin \
                   __m_uvm_status_container.stringv = { "lhs = \"", s__, "\" : rhs = \"", local_data__.ARG[string_aa_key], "\""}; \
                   __m_uvm_status_container.comparer.print_msg(__m_uvm_status_container.stringv); \
                end \
                __m_uvm_status_container.scope.unset_arg(string_aa_key); \
              end \
            end \
           end \
      endcase \
    end \
  end



`define M_UVM_FIELD_SET_AA_TYPE(INDEX_TYPE, ARRAY_TYPE, ARRAY, RHS, FLAG) \
  if((what__ >= UVM_START_FUNCS && what__ <= UVM_END_FUNCS) && (((FLAG)&UVM_READONLY) == 0)) begin \
    bit wildcard_index__; \
    INDEX_TYPE index__; \
    index__ = uvm_get_array_index_``INDEX_TYPE(str__, wildcard_index__); \
    if(what__==UVM_SET``ARRAY_TYPE) \
    begin \
      __m_uvm_status_container.scope.down(`"ARRAY`"); \
      if(uvm_is_array(str__) ) begin\
        if(wildcard_index__) begin \
          if(ARRAY.first(index__)) \
          do begin \
            if(uvm_is_match(str__, {__m_uvm_status_container.scope.get(),$sformatf("[%0d]", index__)}) ||  \
               uvm_is_match(str__, {__m_uvm_status_container.scope.get(),$sformatf("[%0s]", index__)})) begin \
              ARRAY[index__] = RHS; \
              __m_uvm_status_container.status = 1; \
            end \
          end while(ARRAY.next(index__));\
        end \
        else if(uvm_is_match(str__, {__m_uvm_status_container.scope.get(),$sformatf("[%0d]", index__)})) begin \
          ARRAY[index__] = RHS; \
          __m_uvm_status_container.status = 1; \
        end \
        else if(uvm_is_match(str__, {__m_uvm_status_container.scope.get(),$sformatf("[%0s]", index__)})) begin \
          ARRAY[index__] = RHS; \
          __m_uvm_status_container.status = 1; \
        end \
      end \
      __m_uvm_status_container.scope.up(); \
    end \
 end



`define M_UVM_FIELD_SET_AA_OBJECT_TYPE(INDEX_TYPE, ARRAY, FLAG) \
  if((what__ >= UVM_START_FUNCS && what__ <= UVM_END_FUNCS) && (((FLAG)&UVM_READONLY) == 0)) begin \
    bit wildcard_index__; \
    INDEX_TYPE index__; \
    index__ = uvm_get_array_index_``INDEX_TYPE(str__, wildcard_index__); \
    if(what__==UVM_SETOBJ) \
    begin \
      __m_uvm_status_container.scope.down(`"ARRAY`"); \
      if(uvm_is_array(str__) ) begin\
        if(wildcard_index__) begin \
          foreach(ARRAY[_index__]) begin \
            if(uvm_is_match(str__, {__m_uvm_status_container.scope.get(),$sformatf("[%0d]", _index__)}) || \
               uvm_is_match(str__, {__m_uvm_status_container.scope.get(),$sformatf("[%0s]", _index__)})) begin \
              if (__m_uvm_status_container.object != null) \
                $cast(ARRAY[_index__], __m_uvm_status_container.object); \
              __m_uvm_status_container.status = 1; \
            end \
          end \
        end \
        else if(uvm_is_match(str__, {__m_uvm_status_container.scope.get(),$sformatf("[%0d]", index__)})) begin \
          if (__m_uvm_status_container.object != null) \
            $cast(ARRAY[index__], __m_uvm_status_container.object); \
          __m_uvm_status_container.status = 1; \
        end \
        else if(uvm_is_match(str__, {__m_uvm_status_container.scope.get(),$sformatf("[%0s]", index__)})) begin \
          if (__m_uvm_status_container.object != null) \
            $cast(ARRAY[index__], __m_uvm_status_container.object); \
          __m_uvm_status_container.status = 1; \
        end \
      end \
      __m_uvm_status_container.scope.up(); \
    end \
 end



`define M_UVM_FIELD_SET_AA_INT_TYPE(INDEX_TYPE, ARRAY_TYPE, ARRAY, RHS, FLAG) \
  if((what__ >= UVM_START_FUNCS && what__ <= UVM_END_FUNCS) && (((FLAG)&UVM_READONLY) == 0)) begin \
    bit wildcard_index__; \
    INDEX_TYPE index__; \
    string idx__; \
    index__ = uvm_get_array_index_int(str__, wildcard_index__); \
    if(what__==UVM_SET``ARRAY_TYPE) \
    begin \
      __m_uvm_status_container.scope.down(`"ARRAY`"); \
      if(uvm_is_array(str__) ) begin\
        if(wildcard_index__) begin \
          foreach(ARRAY[_index__]) begin \
            $swrite(idx__, __m_uvm_status_container.scope.get(), "[", _index__, "]"); \
            if(uvm_is_match(str__, idx__)) begin \
              ARRAY[_index__] = RHS; \
              __m_uvm_status_container.status = 1; \
            end \
          end \
        end \
        else if(uvm_is_match(str__, {__m_uvm_status_container.scope.get(),$sformatf("[%0d]", index__)})) begin \
          ARRAY[index__] = RHS; \
          __m_uvm_status_container.status = 1; \
        end  \
      end \
      __m_uvm_status_container.scope.up(); \
    end \
 end



`define M_UVM_FIELD_SET_AA_INT_ENUMTYPE(INDEX_TYPE, ARRAY_TYPE, ARRAY, RHS, FLAG) \
  if((what__ >= UVM_START_FUNCS && what__ <= UVM_END_FUNCS) && (((FLAG)&UVM_READONLY) == 0)) begin \
    bit wildcard_index__; \
    INDEX_TYPE index__; \
    string idx__; \
    index__ = INDEX_TYPE'(uvm_get_array_index_int(str__, wildcard_index__)); \
    if(what__==UVM_SET``ARRAY_TYPE) \
    begin \
      __m_uvm_status_container.scope.down(`"ARRAY`"); \
      if(uvm_is_array(str__) ) begin\
        if(wildcard_index__) begin \
          foreach(ARRAY[_index__]) begin \
            $swrite(idx__, __m_uvm_status_container.scope.get(), "[", _index__, "]"); \
            if(uvm_is_match(str__, idx__)) begin \
              ARRAY[_index__] = RHS; \
              __m_uvm_status_container.status = 1; \
            end \
          end \
        end \
        else if(uvm_is_match(str__, {__m_uvm_status_container.scope.get(),$sformatf("[%0d]", index__)})) begin \
          ARRAY[index__] = RHS; \
          __m_uvm_status_container.status = 1; \
        end  \
      end \
      __m_uvm_status_container.scope.up(); \
    end \
 end

`endif 





`ifndef uvm_record_attribute
 `ifdef QUESTA
    `define uvm_record_attribute(TR_HANDLE,NAME,VALUE) \
      $add_attribute(TR_HANDLE,VALUE,NAME);
  `else
    `define uvm_record_attribute(TR_HANDLE,NAME,VALUE) \
      recorder.record_generic(NAME, $sformatf("%p", VALUE)); 
  `endif
`endif


`ifndef uvm_record_int
  `define uvm_record_int(NAME,VALUE,SIZE,RADIX = UVM_NORADIX) \
    if (recorder != null && recorder.is_open()) begin \
      if (recorder.use_record_attribute()) \
        `uvm_record_attribute(recorder.get_record_attribute_handle(),NAME,VALUE) \
      else \
        if (SIZE > 64) \
          recorder.record_field(NAME, VALUE, SIZE, RADIX); \
        else \
          recorder.record_field_int(NAME, VALUE, SIZE, RADIX); \
    end
`endif


`ifndef uvm_record_string
  `define uvm_record_string(NAME,VALUE) \
    if (recorder != null && recorder.is_open()) begin \
      if (recorder.use_record_attribute()) \
        `uvm_record_attribute(recorder.get_record_attribute_handle(),NAME,VALUE) \
      else \
        recorder.record_string(NAME,VALUE); \
    end
`endif

`ifndef uvm_record_time
  `define uvm_record_time(NAME,VALUE) \
    if (recorder != null && recorder.is_open()) begin \
      if (recorder.use_record_attribute()) \
        `uvm_record_attribute(recorder.get_record_attribute_handle(),NAME,VALUE) \
      else \
         recorder.record_time(NAME,VALUE); \
    end
`endif


`ifndef uvm_record_real
  `define uvm_record_real(NAME,VALUE) \
    if (recorder != null && recorder.is_open()) begin \
      if (recorder.use_record_attribute()) \
        `uvm_record_attribute(recorder.get_record_attribute_handle(),NAME,VALUE) \
      else \
        recorder.record_field_real(NAME,VALUE); \
    end
`endif

`define uvm_record_field(NAME,VALUE) \
   if (recorder != null && recorder.is_open()) begin \
     if (recorder.use_record_attribute()) begin \
       `uvm_record_attribute(recorder.get_record_attribute_handle(),NAME,VALUE) \
     end \
     else \
       recorder.record_generic(NAME, $sformatf("%p", VALUE)); \
   end

  



`define uvm_pack_intN(VAR,SIZE) \
  begin \
   int __array[]; \
   begin \
     bit [SIZE-1:0] __vector = VAR; \
     { << int { __array }} = {{($bits(int) - (SIZE % $bits(int))) {1'b0}}, __vector}; \
   end \
   packer.pack_ints(__array, SIZE); \
  end

`define uvm_pack_enumN(VAR,SIZE) \
   `uvm_pack_intN(VAR,SIZE)


`define uvm_pack_sarrayN(VAR,SIZE) \
    begin \
    foreach (VAR `` [index]) \
      `uvm_pack_intN(VAR[index],SIZE) \
    end


`define uvm_pack_arrayN(VAR,SIZE) \
    begin \
    if (packer.use_metadata) \
      `uvm_pack_intN(VAR.size(),32) \
    `uvm_pack_sarrayN(VAR,SIZE) \
    end


`define uvm_pack_queueN(VAR,SIZE) \
   `uvm_pack_arrayN(VAR,SIZE)



`define uvm_pack_int(VAR) \
   `uvm_pack_intN(VAR,$bits(VAR))


`define uvm_pack_enum(VAR) \
   `uvm_pack_enumN(VAR,$bits(VAR))


`define uvm_pack_string(VAR) \
    begin \
    `uvm_pack_sarrayN(VAR,8) \
    if (packer.use_metadata) \
      `uvm_pack_intN(8'b0,8) \
    end


`define uvm_pack_real(VAR) \
   `uvm_pack_intN($realtobits(VAR),64)


`define uvm_pack_sarray(VAR)  \
   `uvm_pack_sarrayN(VAR,$bits(VAR[0]))


`define uvm_pack_array(VAR) \
   `uvm_pack_arrayN(VAR,$bits(VAR[0]))


`define uvm_pack_queue(VAR) \
   `uvm_pack_queueN(VAR,$bits(VAR[0]))





`define uvm_unpack_intN(VAR,SIZE) \
   begin \
      int __array[] = new[(SIZE+31)/32]; \
      bit [(((SIZE + 31) / 32) * 32) - 1:0] __var; \
      packer.unpack_ints(__array, SIZE); \
      __var = { << int { __array }}; \
      VAR = __var; \
   end


`define uvm_unpack_enumN(VAR,SIZE,TYPE) \
   begin \
   if (packer.big_endian) \
     { << { VAR }} = packer.m_bits[packer.count +: SIZE];  \
   else \
     VAR = TYPE'(packer.m_bits[packer.count +: SIZE]); \
   \
   packer.count += SIZE; \
   end


`define uvm_unpack_sarrayN(VAR,SIZE) \
    begin \
    foreach (VAR `` [i]) \
      `uvm_unpack_intN(VAR``[i], SIZE) \
    end


`define uvm_unpack_arrayN(VAR,SIZE) \
    begin \
    int sz__; \
    if (packer.use_metadata) begin \
      `uvm_unpack_intN(sz__,32) \
      VAR = new[sz__]; \
    end \
    `uvm_unpack_sarrayN(VAR,SIZE) \
    end


`define uvm_unpack_queueN(VAR,SIZE) \
    begin \
    int sz__; \
    if (packer.use_metadata) \
      `uvm_unpack_intN(sz__,32) \
    while (VAR.size() > sz__) \
      void'(VAR.pop_back()); \
    for (int i=0; i<sz__; i++) \
      `uvm_unpack_intN(VAR[i],SIZE) \
    end




`define uvm_unpack_int(VAR) \
   `uvm_unpack_intN(VAR,$bits(VAR))


`define uvm_unpack_enum(VAR,TYPE) \
   `uvm_unpack_enumN(VAR,$bits(VAR),TYPE)


`define uvm_unpack_string(VAR) \
  VAR = packer.unpack_string();

`define uvm_unpack_real(VAR) \
   begin \
   longint unsigned real_bits64__; \
   `uvm_unpack_intN(real_bits64__,64) \
   VAR = $bitstoreal(real_bits64__); \
   end


`define uvm_unpack_sarray(VAR)  \
   `uvm_unpack_sarrayN(VAR,$bits(VAR[0]))


`define uvm_unpack_array(VAR) \
   `uvm_unpack_arrayN(VAR,$bits(VAR[0]))


`define uvm_unpack_queue(VAR) \
   `uvm_unpack_queueN(VAR,$bits(VAR[0]))



`endif  



`ifndef UVM_PRINTER_DEFINES_SVH
`define UVM_PRINTER_DEFINES_SVH


`define uvm_print_int(F, R) \
  `uvm_print_int3(F, R, uvm_default_printer)

`define uvm_print_int3(F, R, P) \
   do begin \
     uvm_printer p__; \
     if(P!=null) p__ = P; \
     else p__ = uvm_default_printer; \
     `uvm_print_int4(F, R, `"F`", p__) \
   end while(0);

`define uvm_print_int4(F, R, NM, P) \
    if ($bits(F) > 64) \
      P.print_field(NM, F, $bits(F), R, "["); \
    else \
      P.print_field_int(NM, F, $bits(F), R, "["); 



`define uvm_print_enum(T, F, NM, P) \
    P.print_generic(NM, `"T`", $bits(F), F.name(), "[");



`define uvm_print_object(F) \
  `uvm_print_object2(F, uvm_default_printer)

`define uvm_print_object2(F, P) \
   do begin \
     uvm_printer p__; \
     if(P!=null) p__ = P; \
     else p__ = uvm_default_printer; \
     p__.print_object(`"F`", F, "["); \
   end while(0);



`define uvm_print_string(F) \
  `uvm_print_string2(F, uvm_default_printer)

`define uvm_print_string2(F, P) \
   do begin \
     uvm_printer p__; \
     if(P!=null) p__ = P; \
     else p__ = uvm_default_printer; \
     p__.print_string(`"F`", F, "["); \
   end while(0);



`define uvm_print_array_int(F, R) \
  `uvm_print_array_int3(F, R, uvm_default_printer)
   
`define uvm_print_array_int3(F, R, P) \
  `uvm_print_qda_int4(F, R, P, da)



`define uvm_print_sarray_int3(F, R, P) \
  `uvm_print_qda_int4(F, R, P, sa)

`define uvm_print_qda_int4(F, R, P, T) \
  begin \
    uvm_printer p__; \
    uvm_printer_knobs k__; \
    int curr, max__; max__=0; curr=0; \
    if(P!=null) p__ = P; \
    else p__ = uvm_default_printer; \
    max__ = $right(F)+1; \
    p__.print_array_header (`"F`", max__,`"T``(integral)`"); \
    k__ = p__.knobs; \
    if((p__.knobs.depth == -1) || (p__.m_scope.depth() < p__.knobs.depth+1)) \
    begin \
      foreach(F[i__]) begin \
        if(k__.begin_elements == -1 || k__.end_elements == -1 || curr < k__.begin_elements ) begin \
          `uvm_print_int4(F[curr], R, p__.index_string(curr), p__) \
        end \
        else break; \
        curr++; \
      end \
      if(curr<max__) begin \
        if((max__-k__.end_elements) > curr) curr = max__-k__.end_elements; \
        if(curr<k__.begin_elements) curr = k__.begin_elements; \
        else begin \
          p__.print_array_range(k__.begin_elements, curr-1); \
        end \
        for(curr=curr; curr<max__; ++curr) begin \
          `uvm_print_int4(F[curr], R, p__.index_string(curr), p__) \
        end \
      end \
    end \
    p__.print_array_footer(max__); \
  end
 
`define uvm_print_qda_enum(F, P, T, ET) \
  begin \
    uvm_printer p__; \
    uvm_printer_knobs k__; \
    int curr, max__; max__=0; curr=0; \
    if(P!=null) p__ = P; \
    else p__ = uvm_default_printer; \
    foreach(F[i]) max__ = i+1; \
    p__.print_array_header (`"F`", max__,`"T``(``ET``)`"); \
    k__ = p__.knobs; \
    if((p__.knobs.depth == -1) || (p__.m_scope.depth() < p__.knobs.depth+1)) \
    begin \
      foreach(F[i__]) begin \
        if(k__.begin_elements == -1 || k__.end_elements == -1 || curr < k__.begin_elements ) begin \
          `uvm_print_enum(ET, F[curr], p__.index_string(curr), p__) \
        end \
        else break; \
        curr++; \
      end \
      if(curr<max__) begin \
        if((max__-k__.end_elements) > curr) curr = max__-k__.end_elements; \
        if(curr<k__.begin_elements) curr = k__.begin_elements; \
        else begin \
          p__.print_array_range(k__.begin_elements, curr-1); \
        end \
        for(curr=curr; curr<max__; ++curr) begin \
          `uvm_print_enum(ET, F[curr], p__.index_string(curr), p__) \
        end \
      end \
    end \
    p__.print_array_footer(max__); \
  end
 
`define uvm_print_queue_int(F, R) \
  `uvm_print_queue_int3(F, R, uvm_default_printer)

`define uvm_print_queue_int3(F, R, P) \
  `uvm_print_qda_int3(F, R, P, queue)

`define uvm_print_array_object(F,FLAG) \
  `uvm_print_array_object3(F, uvm_default_printer,FLAG)
   
`define uvm_print_sarray_object(F,FLAG) \
  `uvm_print_sarray_object3(F, uvm_default_printer,FLAG)
   
`define uvm_print_array_object3(F, P,FLAG) \
  `uvm_print_object_qda4(F, P, da,FLAG)

`define uvm_print_sarray_object3(F, P,FLAG) \
  `uvm_print_object_qda4(F, P, sa,FLAG)

`define uvm_print_object_qda4(F, P, T,FLAG) \
  do begin \
    int curr, max__; \
    uvm_printer p__; \
    max__=0; curr=0; \
    if(P!=null) p__ = P; \
    else p__ = uvm_default_printer; \
    foreach(F[i]) max__ = i+1; \
\
\
    p__.m_scope.set_arg(`"F`");\
    p__.print_array_header(`"F`", max__, `"T``(object)`");\
    if((p__.knobs.depth == -1) || (p__.knobs.depth+1 > p__.m_scope.depth())) \
    begin\
      for(curr=0; curr<max__ && (p__.knobs.begin_elements == -1 || \
         p__.knobs.end_elements == -1 || curr<p__.knobs.begin_elements); ++curr) begin \
        if(((FLAG)&UVM_REFERENCE) == 0) \
          p__.print_object(p__.index_string(curr), F[curr], "[");\
        else \
          p__.print_object_header(p__.index_string(curr), F[curr], "[");\
      end \
      if(curr<max__) begin\
        curr = max__-p__.knobs.end_elements;\
        if(curr<p__.knobs.begin_elements) curr = p__.knobs.begin_elements;\
        else begin\
          p__.print_array_range(p__.knobs.begin_elements, curr-1);\
        end\
        for(curr=curr; curr<max__; ++curr) begin\
          if(((FLAG)&UVM_REFERENCE) == 0) \
            p__.print_object(p__.index_string(curr), F[curr], "[");\
          else \
            p__.print_object_header(p__.index_string(curr), F[curr], "[");\
        end \
      end\
    end \
\
    p__.print_array_footer(max__); \
  end while(0);
 
`define uvm_print_object_queue(F,FLAG) \
  `uvm_print_object_queue3(F, uvm_default_printer,FLAG)
   
`define uvm_print_object_queue3(F, P,FLAG) \
  do begin \
    `uvm_print_object_qda4(F,P, queue,FLAG); \
  end while(0);
 
`define uvm_print_array_string(F) \
  `uvm_print_array_string2(F, uvm_default_printer)
   
`define uvm_print_array_string2(F, P) \
   `uvm_print_string_qda3(F, P, da)

`define uvm_print_sarray_string2(F, P) \
   `uvm_print_string_qda3(F, P, sa)

`define uvm_print_string_qda3(F, P, T) \
  do begin \
    int curr, max__; \
    uvm_printer p__; \
    max__=0; curr=0; \
    foreach(F[i]) max__ = i+1; \
    if(P!=null) p__ = P; \
    else p__ = uvm_default_printer; \
\
\
    p__.m_scope.set_arg(`"F`");\
    p__.print_array_header(`"F`", max__, `"T``(string)`");\
    if((p__.knobs.depth == -1) || (p__.knobs.depth+1 > p__.m_scope.depth())) \
    begin\
      for(curr=0; curr<max__ && curr<p__.knobs.begin_elements; ++curr) begin\
        p__.print_string(p__.index_string(curr), F[curr], "[");\
      end \
      if(curr<max__) begin\
        curr = max__-p__.knobs.end_elements;\
        if(curr<p__.knobs.begin_elements) curr = p__.knobs.begin_elements;\
        else begin\
          p__.print_array_range(p__.knobs.begin_elements, curr-1);\
        end\
        for(curr=curr; curr<max__; ++curr) begin\
          p__.print_string(p__.index_string(curr), F[curr], "[");\
        end \
      end\
    end \
\
    p__.print_array_footer(max__); \
  end while(0);
 
`define uvm_print_string_queue(F) \
  `uvm_print_string_queue2(F, uvm_default_printer)
   
`define uvm_print_string_queue2(F, P) \
  do begin \
    `uvm_print_string_qda3(F,P, queue); \
  end while(0);

`define uvm_print_aa_string_int(F) \
  `uvm_print_aa_string_int3(F, R, uvm_default_printer)


`define uvm_print_aa_string_int3(F, R, P) \
  begin \
    uvm_printer p__; \
    uvm_printer_knobs k__; \
    if(P!=null) p__ = P; \
    else p__ = uvm_default_printer; \
    p__.print_array_header (`"F`", F.num(), "aa(int,string)"); \
    k__ = p__.knobs; \
    if((p__.knobs.depth == -1) || (p__.m_scope.depth() < p__.knobs.depth+1)) \
    begin \
      foreach(F[string_aa_key]) \
          `uvm_print_int4(F[string_aa_key], R,  \
                                {"[", string_aa_key, "]"}, p__) \
    end \
    p__.print_array_footer(F.num()); \
  end

`define uvm_print_aa_string_object(F,FLAG) \
  `uvm_print_aa_string_object_3(F, uvm_default_printer,FLAG)
  
`define uvm_print_aa_string_object3(F, P,FLAG) \
  begin \
    uvm_printer p__; \
    uvm_printer_knobs k__; \
    uvm_object u__; \
    if(P!=null) p__ = P; \
    else p__ = uvm_default_printer; \
    p__.print_array_header (`"F`", F.num(), "aa(object,string)"); \
    k__ = p__.knobs; \
    if((p__.knobs.depth == -1) || (p__.m_scope.depth() < p__.knobs.depth+1)) \
    begin \
      foreach(F[string_aa_key]) begin \
          if(((FLAG)&UVM_REFERENCE)==0) \
            p__.print_object({"[", string_aa_key, "]"}, F[string_aa_key], "[");\
          else \
            p__.print_object_header({"[", string_aa_key, "]"}, F[string_aa_key], "[");\
      end \
    end \
    p__.print_array_footer(F.num()); \
  end

`define uvm_print_aa_string_string(F) \
  `uvm_print_aa_string_string_2(F, uvm_default_printer)
  
`define uvm_print_aa_string_string2(F, P) \
  begin \
    uvm_printer p__; \
    uvm_printer_knobs k__; \
    if(P!=null) p__ = P; \
    else p__ = uvm_default_printer; \
    p__.print_array_header (`"F`", F.num(), "aa(string,string)"); \
    k__ = p__.knobs; \
    if((p__.knobs.depth == -1) || (p__.m_scope.depth() < p__.knobs.depth+1)) \
    begin \
      foreach(F[string_aa_key]) \
          p__.print_string({"[", string_aa_key, "]"}, F[string_aa_key], "["); \
    end \
    p__.print_array_footer(F.num()); \
  end

`define uvm_print_aa_int_object(F,FLAG) \
  `uvm_print_aa_int_object_3(F, uvm_default_printer,FLAG)

`define uvm_print_aa_int_object3(F, P,FLAG) \
  begin \
    uvm_printer p__; \
    uvm_printer_knobs k__; \
    uvm_object u__; \
    int key; \
    if(P!=null) p__ = P; \
    else p__ = uvm_default_printer; \
    p__.print_array_header (`"F`", F.num(), "aa(object,int)"); \
    k__ = p__.knobs; \
    if((p__.knobs.depth == -1) || (p__.m_scope.depth() < p__.knobs.depth+1)) \
    begin \
      foreach(F[key]) begin \
          $swrite(__m_uvm_status_container.stringv, "[%0d]", key); \
          if(((FLAG)&UVM_REFERENCE)==0) \
            p__.print_object(__m_uvm_status_container.stringv, F[key], "[");\
          else \
            p__.print_object_header(__m_uvm_status_container.stringv, F[key], "[");\
      end \
    end \
    p__.print_array_footer(F.num()); \
  end

`define uvm_print_aa_int_key4(KEY, F, R, P) \
  begin \
    uvm_printer p__; \
    uvm_printer_knobs k__; \
    if(P!=null) p__ = P; \
    else p__ = uvm_default_printer; \
    __m_uvm_status_container.stringv = "aa(int,int)"; \
    for(int i=0; i<__m_uvm_status_container.stringv.len(); ++i) \
      if(__m_uvm_status_container.stringv[i] == " ") \
        __m_uvm_status_container.stringv[i] = "_"; \
    p__.print_array_header (`"F`", F.num(), __m_uvm_status_container.stringv); \
    k__ = p__.knobs; \
    if((p__.knobs.depth == -1) || (p__.m_scope.depth() < p__.knobs.depth+1)) \
    begin \
      foreach(F[aa_key]) begin \
          `uvm_print_int4(F[aa_key], R,  \
                                {"[", $sformatf("%0d",aa_key), "]"}, p__) \
      end \
    end \
    p__.print_array_footer(F.num()); \
  end

`endif





`define uvm_blocking_put_imp_decl(SFX) \
class uvm_blocking_put_imp``SFX #(type T=int, type IMP=int) \
  extends uvm_port_base #(uvm_tlm_if_base #(T,T)); \
  `UVM_IMP_COMMON(`UVM_TLM_BLOCKING_PUT_MASK,`"uvm_blocking_put_imp``SFX`",IMP) \
  `UVM_BLOCKING_PUT_IMP_SFX(SFX, m_imp, T, t) \
endclass


`define uvm_nonblocking_put_imp_decl(SFX) \
class uvm_nonblocking_put_imp``SFX #(type T=int, type IMP=int) \
  extends uvm_port_base #(uvm_tlm_if_base #(T,T)); \
  `UVM_IMP_COMMON(`UVM_TLM_NONBLOCKING_PUT_MASK,`"uvm_nonblocking_put_imp``SFX`",IMP) \
  `UVM_NONBLOCKING_PUT_IMP_SFX( SFX, m_imp, T, t) \
endclass


`define uvm_put_imp_decl(SFX) \
class uvm_put_imp``SFX #(type T=int, type IMP=int) \
  extends uvm_port_base #(uvm_tlm_if_base #(T,T)); \
  `UVM_IMP_COMMON(`UVM_TLM_PUT_MASK,`"uvm_put_imp``SFX`",IMP) \
  `UVM_BLOCKING_PUT_IMP_SFX(SFX, m_imp, T, t) \
  `UVM_NONBLOCKING_PUT_IMP_SFX(SFX, m_imp, T, t) \
endclass


`define uvm_blocking_get_imp_decl(SFX) \
class uvm_blocking_get_imp``SFX #(type T=int, type IMP=int) \
  extends uvm_port_base #(uvm_tlm_if_base #(T,T)); \
  `UVM_IMP_COMMON(`UVM_TLM_BLOCKING_GET_MASK,`"uvm_blocking_get_imp``SFX`",IMP) \
  `UVM_BLOCKING_GET_IMP_SFX(SFX, m_imp, T, t) \
endclass


`define uvm_nonblocking_get_imp_decl(SFX) \
class uvm_nonblocking_get_imp``SFX #(type T=int, type IMP=int) \
  extends uvm_port_base #(uvm_tlm_if_base #(T,T)); \
  `UVM_IMP_COMMON(`UVM_TLM_NONBLOCKING_GET_MASK,`"uvm_nonblocking_get_imp``SFX`",IMP) \
  `UVM_NONBLOCKING_GET_IMP_SFX(SFX, m_imp, T, t) \
endclass


`define uvm_get_imp_decl(SFX) \
class uvm_get_imp``SFX #(type T=int, type IMP=int) \
  extends uvm_port_base #(uvm_tlm_if_base #(T,T)); \
  `UVM_IMP_COMMON(`UVM_TLM_GET_MASK,`"uvm_get_imp``SFX`",IMP) \
  `UVM_BLOCKING_GET_IMP_SFX(SFX, m_imp, T, t) \
  `UVM_NONBLOCKING_GET_IMP_SFX(SFX, m_imp, T, t) \
endclass


`define uvm_blocking_peek_imp_decl(SFX) \
class uvm_blocking_peek_imp``SFX #(type T=int, type IMP=int) \
  extends uvm_port_base #(uvm_tlm_if_base #(T,T)); \
  `UVM_IMP_COMMON(`UVM_TLM_BLOCKING_PEEK_MASK,`"uvm_blocking_peek_imp``SFX`",IMP) \
  `UVM_BLOCKING_PEEK_IMP_SFX(SFX, m_imp, T, t) \
endclass 


`define uvm_nonblocking_peek_imp_decl(SFX) \
class uvm_nonblocking_peek_imp``SFX #(type T=int, type IMP=int) \
  extends uvm_port_base #(uvm_tlm_if_base #(T,T)); \
  `UVM_IMP_COMMON(`UVM_TLM_NONBLOCKING_PEEK_MASK,`"uvm_nonblocking_peek_imp``SFX`",IMP) \
  `UVM_NONBLOCKING_PEEK_IMP_SFX(SFX, m_imp, T, t) \
endclass


`define uvm_peek_imp_decl(SFX) \
class uvm_peek_imp``SFX #(type T=int, type IMP=int) \
  extends uvm_port_base #(uvm_tlm_if_base #(T,T)); \
  `UVM_IMP_COMMON(`UVM_TLM_PEEK_MASK,`"uvm_peek_imp``SFX`",IMP) \
  `UVM_BLOCKING_PEEK_IMP_SFX(SFX, m_imp, T, t) \
  `UVM_NONBLOCKING_PEEK_IMP_SFX(SFX, m_imp, T, t) \
endclass



`define uvm_blocking_get_peek_imp_decl(SFX) \
class uvm_blocking_get_peek_imp``SFX #(type T=int, type IMP=int) \
  extends uvm_port_base #(uvm_tlm_if_base #(T,T)); \
  `UVM_IMP_COMMON(`UVM_TLM_BLOCKING_GET_PEEK_MASK,`"uvm_blocking_get_peek_imp``SFX`",IMP) \
  `UVM_BLOCKING_GET_IMP_SFX(SFX, m_imp, T, t) \
  `UVM_BLOCKING_PEEK_IMP_SFX(SFX, m_imp, T, t) \
endclass


`define uvm_nonblocking_get_peek_imp_decl(SFX) \
class uvm_nonblocking_get_peek_imp``SFX #(type T=int, type IMP=int) \
  extends uvm_port_base #(uvm_tlm_if_base #(T,T)); \
  `UVM_IMP_COMMON(`UVM_TLM_NONBLOCKING_GET_PEEK_MASK,`"uvm_nonblocking_get_peek_imp``SFX`",IMP) \
  `UVM_NONBLOCKING_GET_IMP_SFX(SFX, m_imp, T, t) \
  `UVM_NONBLOCKING_PEEK_IMP_SFX(SFX, m_imp, T, t) \
endclass



`define uvm_get_peek_imp_decl(SFX) \
class uvm_get_peek_imp``SFX #(type T=int, type IMP=int) \
  extends uvm_port_base #(uvm_tlm_if_base #(T,T)); \
  `UVM_IMP_COMMON(`UVM_TLM_GET_PEEK_MASK,`"uvm_get_peek_imp``SFX`",IMP) \
  `UVM_BLOCKING_GET_IMP_SFX(SFX, m_imp, T, t) \
  `UVM_NONBLOCKING_GET_IMP_SFX(SFX, m_imp, T, t) \
  `UVM_BLOCKING_PEEK_IMP_SFX(SFX, m_imp, T, t) \
  `UVM_NONBLOCKING_PEEK_IMP_SFX(SFX, m_imp, T, t) \
endclass


`define uvm_blocking_master_imp_decl(SFX) \
class uvm_blocking_master_imp``SFX #(type REQ=int, type RSP=int, type IMP=int, \
                                     type REQ_IMP=IMP, type RSP_IMP=IMP) \
  extends uvm_port_base #(uvm_tlm_if_base #(REQ, RSP)); \
  typedef IMP     this_imp_type; \
  typedef REQ_IMP this_req_type; \
  typedef RSP_IMP this_rsp_type; \
  `UVM_MS_IMP_COMMON(`UVM_TLM_BLOCKING_MASTER_MASK,`"uvm_blocking_master_imp``SFX`") \
  \
  `UVM_BLOCKING_PUT_IMP_SFX(SFX, m_req_imp, REQ, t)  \
  \
  `UVM_BLOCKING_GET_IMP_SFX(SFX, m_rsp_imp, RSP, t)  \
  `UVM_BLOCKING_PEEK_IMP_SFX(SFX, m_rsp_imp, RSP, t)  \
  \
endclass


`define uvm_nonblocking_master_imp_decl(SFX) \
class uvm_nonblocking_master_imp``SFX #(type REQ=int, type RSP=int, type IMP=int, \
                                   type REQ_IMP=IMP, type RSP_IMP=IMP) \
  extends uvm_port_base #(uvm_tlm_if_base #(REQ, RSP)); \
  typedef IMP     this_imp_type; \
  typedef REQ_IMP this_req_type; \
  typedef RSP_IMP this_rsp_type; \
  `UVM_MS_IMP_COMMON(`UVM_TLM_NONBLOCKING_MASTER_MASK,`"uvm_nonblocking_master_imp``SFX`") \
  \
  `UVM_NONBLOCKING_PUT_IMP_SFX(SFX, m_req_imp, REQ, t)  \
  \
  `UVM_NONBLOCKING_GET_IMP_SFX(SFX, m_rsp_imp, RSP, t)  \
  `UVM_NONBLOCKING_PEEK_IMP_SFX(SFX, m_rsp_imp, RSP, t)  \
  \
endclass


`define uvm_master_imp_decl(SFX) \
class uvm_master_imp``SFX #(type REQ=int, type RSP=int, type IMP=int, \
                            type REQ_IMP=IMP, type RSP_IMP=IMP) \
  extends uvm_port_base #(uvm_tlm_if_base #(REQ, RSP)); \
  typedef IMP     this_imp_type; \
  typedef REQ_IMP this_req_type; \
  typedef RSP_IMP this_rsp_type; \
  `UVM_MS_IMP_COMMON(`UVM_TLM_MASTER_MASK,`"uvm_master_imp``SFX`") \
  \
  `UVM_BLOCKING_PUT_IMP_SFX(SFX, m_req_imp, REQ, t)  \
  `UVM_NONBLOCKING_PUT_IMP_SFX(SFX, m_req_imp, REQ, t)  \
  \
  `UVM_BLOCKING_GET_IMP_SFX(SFX, m_rsp_imp, RSP, t)  \
  `UVM_BLOCKING_PEEK_IMP_SFX(SFX, m_rsp_imp, RSP, t)  \
  `UVM_NONBLOCKING_GET_IMP_SFX(SFX, m_rsp_imp, RSP, t)  \
  `UVM_NONBLOCKING_PEEK_IMP_SFX(SFX, m_rsp_imp, RSP, t)  \
  \
endclass


`define uvm_blocking_slave_imp_decl(SFX) \
class uvm_blocking_slave_imp``SFX #(type REQ=int, type RSP=int, type IMP=int, \
                                    type REQ_IMP=IMP, type RSP_IMP=IMP) \
  extends uvm_port_base #(uvm_tlm_if_base #(RSP, REQ)); \
  typedef IMP     this_imp_type; \
  typedef REQ_IMP this_req_type; \
  typedef RSP_IMP this_rsp_type; \
  `UVM_MS_IMP_COMMON(`UVM_TLM_BLOCKING_SLAVE_MASK,`"uvm_blocking_slave_imp``SFX`") \
  \
  `UVM_BLOCKING_PUT_IMP_SFX(SFX, m_rsp_imp, RSP, t)  \
  \
  `UVM_BLOCKING_GET_IMP_SFX(SFX, m_req_imp, REQ, t)  \
  `UVM_BLOCKING_PEEK_IMP_SFX(SFX, m_req_imp, REQ, t)  \
  \
endclass


`define uvm_nonblocking_slave_imp_decl(SFX) \
class uvm_nonblocking_slave_imp``SFX #(type REQ=int, type RSP=int, type IMP=int, \
                                       type REQ_IMP=IMP, type RSP_IMP=IMP) \
  extends uvm_port_base #(uvm_tlm_if_base #(RSP, REQ)); \
  typedef IMP     this_imp_type; \
  typedef REQ_IMP this_req_type; \
  typedef RSP_IMP this_rsp_type; \
  `UVM_MS_IMP_COMMON(`UVM_TLM_NONBLOCKING_SLAVE_MASK,`"uvm_nonblocking_slave_imp``SFX`") \
  \
  `UVM_NONBLOCKING_PUT_IMP_SFX(SFX, m_rsp_imp, RSP, t)  \
  \
  `UVM_NONBLOCKING_GET_IMP_SFX(SFX, m_req_imp, REQ, t)  \
  `UVM_NONBLOCKING_PEEK_IMP_SFX(SFX, m_req_imp, REQ, t)  \
  \
endclass


`define uvm_slave_imp_decl(SFX) \
class uvm_slave_imp``SFX #(type REQ=int, type RSP=int, type IMP=int, \
                           type REQ_IMP=IMP, type RSP_IMP=IMP) \
  extends uvm_port_base #(uvm_tlm_if_base #(RSP, REQ)); \
  typedef IMP     this_imp_type; \
  typedef REQ_IMP this_req_type; \
  typedef RSP_IMP this_rsp_type; \
  `UVM_MS_IMP_COMMON(`UVM_TLM_SLAVE_MASK,`"uvm_slave_imp``SFX`") \
  \
  `UVM_BLOCKING_PUT_IMP_SFX(SFX, m_rsp_imp, RSP, t)  \
  `UVM_NONBLOCKING_PUT_IMP_SFX(SFX, m_rsp_imp, RSP, t)  \
  \
  `UVM_BLOCKING_GET_IMP_SFX(SFX, m_req_imp, REQ, t)  \
  `UVM_BLOCKING_PEEK_IMP_SFX(SFX, m_req_imp, REQ, t)  \
  `UVM_NONBLOCKING_GET_IMP_SFX(SFX, m_req_imp, REQ, t)  \
  `UVM_NONBLOCKING_PEEK_IMP_SFX(SFX, m_req_imp, REQ, t)  \
  \
endclass


`define uvm_blocking_transport_imp_decl(SFX) \
class uvm_blocking_transport_imp``SFX #(type REQ=int, type RSP=int, type IMP=int) \
  extends uvm_port_base #(uvm_tlm_if_base #(REQ, RSP)); \
  `UVM_IMP_COMMON(`UVM_TLM_BLOCKING_TRANSPORT_MASK,`"uvm_blocking_transport_imp``SFX`",IMP) \
  `UVM_BLOCKING_TRANSPORT_IMP_SFX(SFX, m_imp, REQ, RSP, req, rsp) \
endclass


`define uvm_nonblocking_transport_imp_decl(SFX) \
class uvm_nonblocking_transport_imp``SFX #(type REQ=int, type RSP=int, type IMP=int) \
  extends uvm_port_base #(uvm_tlm_if_base #(REQ, RSP)); \
  `UVM_IMP_COMMON(`UVM_TLM_NONBLOCKING_TRANSPORT_MASK,`"uvm_nonblocking_transport_imp``SFX`",IMP) \
  `UVM_NONBLOCKING_TRANSPORT_IMP_SFX(SFX, m_imp, REQ, RSP, req, rsp) \
endclass

`define uvm_non_blocking_transport_imp_decl(SFX) \
  `uvm_nonblocking_transport_imp_decl(SFX)


`define uvm_transport_imp_decl(SFX) \
class uvm_transport_imp``SFX #(type REQ=int, type RSP=int, type IMP=int) \
  extends uvm_port_base #(uvm_tlm_if_base #(REQ, RSP)); \
  `UVM_IMP_COMMON(`UVM_TLM_TRANSPORT_MASK,`"uvm_transport_imp``SFX`",IMP) \
  `UVM_BLOCKING_TRANSPORT_IMP_SFX(SFX, m_imp, REQ, RSP, req, rsp) \
  `UVM_NONBLOCKING_TRANSPORT_IMP_SFX(SFX, m_imp, REQ, RSP, req, rsp) \
endclass


`define uvm_analysis_imp_decl(SFX) \
class uvm_analysis_imp``SFX #(type T=int, type IMP=int) \
  extends uvm_port_base #(uvm_tlm_if_base #(T,T)); \
  `UVM_IMP_COMMON(`UVM_TLM_ANALYSIS_MASK,`"uvm_analysis_imp``SFX`",IMP) \
  function void write( input T t); \
    m_imp.write``SFX( t); \
  endfunction \
  \
endclass



`define UVM_BLOCKING_PUT_IMP_SFX(SFX, imp, TYPE, arg) \
  task put( input TYPE arg); imp.put``SFX( arg); endtask

`define UVM_BLOCKING_GET_IMP_SFX(SFX, imp, TYPE, arg) \
  task get( output TYPE arg); imp.get``SFX( arg); endtask

`define UVM_BLOCKING_PEEK_IMP_SFX(SFX, imp, TYPE, arg) \
  task peek( output TYPE arg);imp.peek``SFX( arg); endtask

`define UVM_NONBLOCKING_PUT_IMP_SFX(SFX, imp, TYPE, arg) \
  function bit try_put( input TYPE arg); \
    if( !imp.try_put``SFX( arg)) return 0; \
    return 1; \
  endfunction \
  function bit can_put(); return imp.can_put``SFX(); endfunction

`define UVM_NONBLOCKING_GET_IMP_SFX(SFX, imp, TYPE, arg) \
  function bit try_get( output TYPE arg); \
    if( !imp.try_get``SFX( arg)) return 0; \
    return 1; \
  endfunction \
  function bit can_get(); return imp.can_get``SFX(); endfunction

`define UVM_NONBLOCKING_PEEK_IMP_SFX(SFX, imp, TYPE, arg) \
  function bit try_peek( output TYPE arg); \
    if( !imp.try_peek``SFX( arg)) return 0; \
    return 1; \
  endfunction \
  function bit can_peek(); return imp.can_peek``SFX(); endfunction

`define UVM_BLOCKING_TRANSPORT_IMP_SFX(SFX, imp, REQ, RSP, req_arg, rsp_arg) \
  task transport( input REQ req_arg, output RSP rsp_arg); \
    imp.transport``SFX(req_arg, rsp_arg); \
  endtask

`define UVM_NONBLOCKING_TRANSPORT_IMP_SFX(SFX, imp, REQ, RSP, req_arg, rsp_arg) \
  function bit nb_transport( input REQ req_arg, output RSP rsp_arg); \
    if(imp) return imp.nb_transport``SFX(req_arg, rsp_arg); \
  endfunction

`define UVM_SEQ_ITEM_PULL_IMP(imp, REQ, RSP, req_arg, rsp_arg) \
  function void disable_auto_item_recording(); imp.disable_auto_item_recording(); endfunction \
  function bit is_auto_item_recording_enabled(); return imp.is_auto_item_recording_enabled(); endfunction \
  task get_next_item(output REQ req_arg); imp.get_next_item(req_arg); endtask \
  task try_next_item(output REQ req_arg); imp.try_next_item(req_arg); endtask \
  function void item_done(input RSP rsp_arg = null); imp.item_done(rsp_arg); endfunction \
  task wait_for_sequences(); imp.wait_for_sequences(); endtask \
  function bit has_do_available(); return imp.has_do_available(); endfunction \
  function void put_response(input RSP rsp_arg); imp.put_response(rsp_arg); endfunction \
  task get(output REQ req_arg); imp.get(req_arg); endtask \
  task peek(output REQ req_arg); imp.peek(req_arg); endtask \
  task put(input RSP rsp_arg); imp.put(rsp_arg); endtask

`define UVM_TLM_BLOCKING_PUT_MASK          (1<<0)
`define UVM_TLM_BLOCKING_GET_MASK          (1<<1)
`define UVM_TLM_BLOCKING_PEEK_MASK         (1<<2)
`define UVM_TLM_BLOCKING_TRANSPORT_MASK    (1<<3)

`define UVM_TLM_NONBLOCKING_PUT_MASK       (1<<4)
`define UVM_TLM_NONBLOCKING_GET_MASK       (1<<5)
`define UVM_TLM_NONBLOCKING_PEEK_MASK      (1<<6)
`define UVM_TLM_NONBLOCKING_TRANSPORT_MASK (1<<7)

`define UVM_TLM_ANALYSIS_MASK              (1<<8)

`define UVM_TLM_MASTER_BIT_MASK            (1<<9)
`define UVM_TLM_SLAVE_BIT_MASK             (1<<10)
`define UVM_TLM_PUT_MASK                  (`UVM_TLM_BLOCKING_PUT_MASK    | `UVM_TLM_NONBLOCKING_PUT_MASK)
`define UVM_TLM_GET_MASK                  (`UVM_TLM_BLOCKING_GET_MASK    | `UVM_TLM_NONBLOCKING_GET_MASK)
`define UVM_TLM_PEEK_MASK                 (`UVM_TLM_BLOCKING_PEEK_MASK   | `UVM_TLM_NONBLOCKING_PEEK_MASK)

`define UVM_TLM_BLOCKING_GET_PEEK_MASK    (`UVM_TLM_BLOCKING_GET_MASK    | `UVM_TLM_BLOCKING_PEEK_MASK)
`define UVM_TLM_BLOCKING_MASTER_MASK      (`UVM_TLM_BLOCKING_PUT_MASK       | `UVM_TLM_BLOCKING_GET_MASK | `UVM_TLM_BLOCKING_PEEK_MASK | `UVM_TLM_MASTER_BIT_MASK)
`define UVM_TLM_BLOCKING_SLAVE_MASK       (`UVM_TLM_BLOCKING_PUT_MASK       | `UVM_TLM_BLOCKING_GET_MASK | `UVM_TLM_BLOCKING_PEEK_MASK | `UVM_TLM_SLAVE_BIT_MASK)

`define UVM_TLM_NONBLOCKING_GET_PEEK_MASK (`UVM_TLM_NONBLOCKING_GET_MASK | `UVM_TLM_NONBLOCKING_PEEK_MASK)
`define UVM_TLM_NONBLOCKING_MASTER_MASK   (`UVM_TLM_NONBLOCKING_PUT_MASK    | `UVM_TLM_NONBLOCKING_GET_MASK | `UVM_TLM_NONBLOCKING_PEEK_MASK | `UVM_TLM_MASTER_BIT_MASK)
`define UVM_TLM_NONBLOCKING_SLAVE_MASK    (`UVM_TLM_NONBLOCKING_PUT_MASK    | `UVM_TLM_NONBLOCKING_GET_MASK | `UVM_TLM_NONBLOCKING_PEEK_MASK | `UVM_TLM_SLAVE_BIT_MASK)

`define UVM_TLM_GET_PEEK_MASK             (`UVM_TLM_GET_MASK | `UVM_TLM_PEEK_MASK)
`define UVM_TLM_MASTER_MASK               (`UVM_TLM_BLOCKING_MASTER_MASK    | `UVM_TLM_NONBLOCKING_MASTER_MASK)
`define UVM_TLM_SLAVE_MASK                (`UVM_TLM_BLOCKING_SLAVE_MASK    | `UVM_TLM_NONBLOCKING_SLAVE_MASK)
`define UVM_TLM_TRANSPORT_MASK            (`UVM_TLM_BLOCKING_TRANSPORT_MASK | `UVM_TLM_NONBLOCKING_TRANSPORT_MASK)

`define UVM_SEQ_ITEM_GET_NEXT_ITEM_MASK       (1<<0)
`define UVM_SEQ_ITEM_TRY_NEXT_ITEM_MASK       (1<<1)
`define UVM_SEQ_ITEM_ITEM_DONE_MASK           (1<<2)
`define UVM_SEQ_ITEM_HAS_DO_AVAILABLE_MASK    (1<<3)
`define UVM_SEQ_ITEM_WAIT_FOR_SEQUENCES_MASK  (1<<4)
`define UVM_SEQ_ITEM_PUT_RESPONSE_MASK        (1<<5)
`define UVM_SEQ_ITEM_PUT_MASK                 (1<<6)
`define UVM_SEQ_ITEM_GET_MASK                 (1<<7)
`define UVM_SEQ_ITEM_PEEK_MASK                (1<<8)

`define UVM_SEQ_ITEM_PULL_MASK  (`UVM_SEQ_ITEM_GET_NEXT_ITEM_MASK | `UVM_SEQ_ITEM_TRY_NEXT_ITEM_MASK | \
                        `UVM_SEQ_ITEM_ITEM_DONE_MASK | `UVM_SEQ_ITEM_HAS_DO_AVAILABLE_MASK |  \
                        `UVM_SEQ_ITEM_WAIT_FOR_SEQUENCES_MASK | `UVM_SEQ_ITEM_PUT_RESPONSE_MASK | \
                        `UVM_SEQ_ITEM_PUT_MASK | `UVM_SEQ_ITEM_GET_MASK | `UVM_SEQ_ITEM_PEEK_MASK)

`define UVM_SEQ_ITEM_UNI_PULL_MASK (`UVM_SEQ_ITEM_GET_NEXT_ITEM_MASK | `UVM_SEQ_ITEM_TRY_NEXT_ITEM_MASK | \
                           `UVM_SEQ_ITEM_ITEM_DONE_MASK | `UVM_SEQ_ITEM_HAS_DO_AVAILABLE_MASK | \
                           `UVM_SEQ_ITEM_WAIT_FOR_SEQUENCES_MASK | `UVM_SEQ_ITEM_GET_MASK | \
                           `UVM_SEQ_ITEM_PEEK_MASK)

`define UVM_SEQ_ITEM_PUSH_MASK  (`UVM_SEQ_ITEM_PUT_MASK)


`ifndef UVM_TLM_IMPS_SVH
`define UVM_TLM_IMPS_SVH







`define UVM_BLOCKING_PUT_IMP(imp, TYPE, arg) \
  task put (TYPE arg); \
    imp.put(arg); \
  endtask

`define UVM_NONBLOCKING_PUT_IMP(imp, TYPE, arg) \
  function bit try_put (TYPE arg); \
    return imp.try_put(arg); \
  endfunction \
  function bit can_put(); \
    return imp.can_put(); \
  endfunction

`define UVM_BLOCKING_GET_IMP(imp, TYPE, arg) \
  task get (output TYPE arg); \
    imp.get(arg); \
  endtask

`define UVM_NONBLOCKING_GET_IMP(imp, TYPE, arg) \
  function bit try_get (output TYPE arg); \
    return imp.try_get(arg); \
  endfunction \
  function bit can_get(); \
    return imp.can_get(); \
  endfunction

`define UVM_BLOCKING_PEEK_IMP(imp, TYPE, arg) \
  task peek (output TYPE arg); \
    imp.peek(arg); \
  endtask

`define UVM_NONBLOCKING_PEEK_IMP(imp, TYPE, arg) \
  function bit try_peek (output TYPE arg); \
    return imp.try_peek(arg); \
  endfunction \
  function bit can_peek(); \
    return imp.can_peek(); \
  endfunction

`define UVM_BLOCKING_TRANSPORT_IMP(imp, REQ, RSP, req_arg, rsp_arg) \
  task transport (REQ req_arg, output RSP rsp_arg); \
    imp.transport(req_arg, rsp_arg); \
  endtask

`define UVM_NONBLOCKING_TRANSPORT_IMP(imp, REQ, RSP, req_arg, rsp_arg) \
  function bit nb_transport (REQ req_arg, output RSP rsp_arg); \
    return imp.nb_transport(req_arg, rsp_arg); \
  endfunction

`define UVM_PUT_IMP(imp, TYPE, arg) \
  `UVM_BLOCKING_PUT_IMP(imp, TYPE, arg) \
  `UVM_NONBLOCKING_PUT_IMP(imp, TYPE, arg)

`define UVM_GET_IMP(imp, TYPE, arg) \
  `UVM_BLOCKING_GET_IMP(imp, TYPE, arg) \
  `UVM_NONBLOCKING_GET_IMP(imp, TYPE, arg)

`define UVM_PEEK_IMP(imp, TYPE, arg) \
  `UVM_BLOCKING_PEEK_IMP(imp, TYPE, arg) \
  `UVM_NONBLOCKING_PEEK_IMP(imp, TYPE, arg)

`define UVM_BLOCKING_GET_PEEK_IMP(imp, TYPE, arg) \
  `UVM_BLOCKING_GET_IMP(imp, TYPE, arg) \
  `UVM_BLOCKING_PEEK_IMP(imp, TYPE, arg)

`define UVM_NONBLOCKING_GET_PEEK_IMP(imp, TYPE, arg) \
  `UVM_NONBLOCKING_GET_IMP(imp, TYPE, arg) \
  `UVM_NONBLOCKING_PEEK_IMP(imp, TYPE, arg)

`define UVM_GET_PEEK_IMP(imp, TYPE, arg) \
  `UVM_BLOCKING_GET_PEEK_IMP(imp, TYPE, arg) \
  `UVM_NONBLOCKING_GET_PEEK_IMP(imp, TYPE, arg)

`define UVM_TRANSPORT_IMP(imp, REQ, RSP, req_arg, rsp_arg) \
  `UVM_BLOCKING_TRANSPORT_IMP(imp, REQ, RSP, req_arg, rsp_arg) \
  `UVM_NONBLOCKING_TRANSPORT_IMP(imp, REQ, RSP, req_arg, rsp_arg)



`define UVM_TLM_GET_TYPE_NAME(NAME) \
  virtual function string get_type_name(); \
    return NAME; \
  endfunction

`define UVM_PORT_COMMON(MASK,TYPE_NAME) \
  function new (string name, uvm_component parent, \
                int min_size=1, int max_size=1); \
    super.new (name, parent, UVM_PORT, min_size, max_size); \
    m_if_mask = MASK; \
  endfunction \
  `UVM_TLM_GET_TYPE_NAME(TYPE_NAME)

`define UVM_SEQ_PORT(MASK,TYPE_NAME) \
  function new (string name, uvm_component parent, \
                int min_size=0, int max_size=1); \
    super.new (name, parent, UVM_PORT, min_size, max_size); \
    m_if_mask = MASK; \
  endfunction \
  `UVM_TLM_GET_TYPE_NAME(TYPE_NAME)
  
`define UVM_EXPORT_COMMON(MASK,TYPE_NAME) \
  function new (string name, uvm_component parent, \
                int min_size=1, int max_size=1); \
    super.new (name, parent, UVM_EXPORT, min_size, max_size); \
    m_if_mask = MASK; \
  endfunction \
  `UVM_TLM_GET_TYPE_NAME(TYPE_NAME)
  
`define UVM_IMP_COMMON(MASK,TYPE_NAME,IMP) \
  local IMP m_imp; \
  function new (string name, IMP imp); \
    super.new (name, imp, UVM_IMPLEMENTATION, 1, 1); \
    m_imp = imp; \
    m_if_mask = MASK; \
  endfunction \
  `UVM_TLM_GET_TYPE_NAME(TYPE_NAME)

`define UVM_MS_IMP_COMMON(MASK,TYPE_NAME) \
  local this_req_type m_req_imp; \
  local this_rsp_type m_rsp_imp; \
  function new (string name, this_imp_type imp, \
                this_req_type req_imp = null, this_rsp_type rsp_imp = null); \
    super.new (name, imp, UVM_IMPLEMENTATION, 1, 1); \
    if(req_imp==null) $cast(req_imp, imp); \
    if(rsp_imp==null) $cast(rsp_imp, imp); \
    m_req_imp = req_imp; \
    m_rsp_imp = rsp_imp; \
    m_if_mask = MASK; \
  endfunction  \
  `UVM_TLM_GET_TYPE_NAME(TYPE_NAME)

`endif








`define uvm_create(SEQ_OR_ITEM) \
  `uvm_create_on(SEQ_OR_ITEM, m_sequencer)



`define uvm_do(SEQ_OR_ITEM) \
  `uvm_do_on_pri_with(SEQ_OR_ITEM, m_sequencer, -1, {})



`define uvm_do_pri(SEQ_OR_ITEM, PRIORITY) \
  `uvm_do_on_pri_with(SEQ_OR_ITEM, m_sequencer, PRIORITY, {})



`define uvm_do_with(SEQ_OR_ITEM, CONSTRAINTS) \
  `uvm_do_on_pri_with(SEQ_OR_ITEM, m_sequencer, -1, CONSTRAINTS)



`define uvm_do_pri_with(SEQ_OR_ITEM, PRIORITY, CONSTRAINTS) \
  `uvm_do_on_pri_with(SEQ_OR_ITEM, m_sequencer, PRIORITY, CONSTRAINTS)




`define uvm_create_on(SEQ_OR_ITEM, SEQR) \
  begin \
  uvm_object_wrapper w_; \
  w_ = SEQ_OR_ITEM.get_type(); \
  $cast(SEQ_OR_ITEM , create_item(w_, SEQR, `"SEQ_OR_ITEM`"));\
  end



`define uvm_do_on(SEQ_OR_ITEM, SEQR) \
  `uvm_do_on_pri_with(SEQ_OR_ITEM, SEQR, -1, {})



`define uvm_do_on_pri(SEQ_OR_ITEM, SEQR, PRIORITY) \
  `uvm_do_on_pri_with(SEQ_OR_ITEM, SEQR, PRIORITY, {})



`define uvm_do_on_with(SEQ_OR_ITEM, SEQR, CONSTRAINTS) \
  `uvm_do_on_pri_with(SEQ_OR_ITEM, SEQR, -1, CONSTRAINTS)



`define uvm_do_on_pri_with(SEQ_OR_ITEM, SEQR, PRIORITY, CONSTRAINTS) \
  begin \
  uvm_sequence_base __seq; \
  `uvm_create_on(SEQ_OR_ITEM, SEQR) \
  if (!$cast(__seq,SEQ_OR_ITEM)) start_item(SEQ_OR_ITEM, PRIORITY);\
  if ((__seq == null || !__seq.do_not_randomize) && !SEQ_OR_ITEM.randomize() with CONSTRAINTS ) begin \
    `uvm_warning("RNDFLD", "Randomization failed in uvm_do_with action") \
  end\
  if (!$cast(__seq,SEQ_OR_ITEM)) finish_item(SEQ_OR_ITEM, PRIORITY); \
  else __seq.start(SEQR, this, PRIORITY, 0); \
  end





`define uvm_send(SEQ_OR_ITEM) \
  `uvm_send_pri(SEQ_OR_ITEM, -1)
  


`define uvm_send_pri(SEQ_OR_ITEM, PRIORITY) \
  begin \
  uvm_sequence_base __seq; \
  if (!$cast(__seq,SEQ_OR_ITEM)) begin \
     start_item(SEQ_OR_ITEM, PRIORITY);\
     finish_item(SEQ_OR_ITEM, PRIORITY);\
  end \
  else __seq.start(__seq.get_sequencer(), this, PRIORITY, 0);\
  end
  


`define uvm_rand_send(SEQ_OR_ITEM) \
  `uvm_rand_send_pri_with(SEQ_OR_ITEM, -1, {})



`define uvm_rand_send_pri(SEQ_OR_ITEM, PRIORITY) \
  `uvm_rand_send_pri_with(SEQ_OR_ITEM, PRIORITY, {})



`define uvm_rand_send_with(SEQ_OR_ITEM, CONSTRAINTS) \
  `uvm_rand_send_pri_with(SEQ_OR_ITEM, -1, CONSTRAINTS)



`define uvm_rand_send_pri_with(SEQ_OR_ITEM, PRIORITY, CONSTRAINTS) \
  begin \
  uvm_sequence_base __seq; \
  if (!$cast(__seq,SEQ_OR_ITEM)) start_item(SEQ_OR_ITEM, PRIORITY);\
  else __seq.set_item_context(this,SEQ_OR_ITEM.get_sequencer()); \
  if ((__seq == null || !__seq.do_not_randomize) && !SEQ_OR_ITEM.randomize() with CONSTRAINTS ) begin \
    `uvm_warning("RNDFLD", "Randomization failed in uvm_rand_send_with action") \
  end\
  if (!$cast(__seq,SEQ_OR_ITEM)) finish_item(SEQ_OR_ITEM, PRIORITY);\
  else __seq.start(__seq.get_sequencer(), this, PRIORITY, 0);\
  end


`define uvm_create_seq(UVM_SEQ, SEQR_CONS_IF) \
  `uvm_create_on(UVM_SEQ, SEQR_CONS_IF.consumer_seqr) \

`define uvm_do_seq(UVM_SEQ, SEQR_CONS_IF) \
  `uvm_do_on(UVM_SEQ, SEQR_CONS_IF.consumer_seqr) \

`define uvm_do_seq_with(UVM_SEQ, SEQR_CONS_IF, CONSTRAINTS) \
  `uvm_do_on_with(UVM_SEQ, SEQR_CONS_IF.consumer_seqr, CONSTRAINTS) \







`define uvm_add_to_seq_lib(TYPE,LIBTYPE) \
   static bit add_``TYPE``_to_seq_lib_``LIBTYPE =\
      LIBTYPE::m_add_typewide_sequence(TYPE::get_type());




`define uvm_sequence_library_utils(TYPE) \
\
   static protected uvm_object_wrapper m_typewide_sequences[$]; \
   \
   function void init_sequence_library(); \
     foreach (TYPE::m_typewide_sequences[i]) \
       sequences.push_back(TYPE::m_typewide_sequences[i]); \
   endfunction \
   \
   static function void add_typewide_sequence(uvm_object_wrapper seq_type); \
     if (m_static_check(seq_type)) \
       TYPE::m_typewide_sequences.push_back(seq_type); \
   endfunction \
   \
   static function void add_typewide_sequences(uvm_object_wrapper seq_types[$]); \
     foreach (seq_types[i]) \
       TYPE::add_typewide_sequence(seq_types[i]); \
   endfunction \
   \
   static function bit m_add_typewide_sequence(uvm_object_wrapper seq_type); \
     TYPE::add_typewide_sequence(seq_type); \
     return 1; \
   endfunction






`define uvm_declare_p_sequencer(SEQUENCER) \
  SEQUENCER p_sequencer;\
  virtual function void m_set_p_sequencer();\
    super.m_set_p_sequencer(); \
    if( !$cast(p_sequencer, m_sequencer)) \
        `uvm_fatal("DCLPSQ", \
        $sformatf("%m %s Error casting p_sequencer, please verify that this sequence/sequence item is intended to execute on this type of sequencer", get_full_name())) \
  endfunction  


`ifndef UVM_CB_MACROS_SVH
`define UVM_CB_MACROS_SVH




`define uvm_register_cb(T,CB) \
  static local bit m_register_cb_``CB = uvm_callbacks#(T,CB)::m_register_pair(`"T`",`"CB`");



`define uvm_set_super_type(T,ST) \
  static local bit m_register_``T``ST = uvm_derived_callbacks#(T,ST)::register_super_type(`"T`",`"ST`"); 




`define uvm_do_callbacks(T,CB,METHOD) \
  `uvm_do_obj_callbacks(T,CB,this,METHOD)



`define uvm_do_obj_callbacks(T,CB,OBJ,METHOD) \
   begin \
     uvm_callback_iter#(T,CB) iter = new(OBJ); \
     CB cb = iter.first(); \
     while(cb != null) begin \
       `uvm_cb_trace_noobj(cb,$sformatf(`"Executing callback method 'METHOD' for callback %s (CB) from %s (T)`",cb.get_name(), OBJ.get_full_name())) \
       cb.METHOD; \
       cb = iter.next(); \
     end \
   end






`define uvm_do_callbacks_exit_on(T,CB,METHOD,VAL) \
  `uvm_do_obj_callbacks_exit_on(T,CB,this,METHOD,VAL) \



`define uvm_do_obj_callbacks_exit_on(T,CB,OBJ,METHOD,VAL) \
   begin \
     uvm_callback_iter#(T,CB) iter = new(OBJ); \
     CB cb = iter.first(); \
     while(cb != null) begin \
       if (cb.METHOD == VAL) begin \
         `uvm_cb_trace_noobj(cb,$sformatf(`"Executed callback method 'METHOD' for callback %s (CB) from %s (T) : returned value VAL (other callbacks will be ignored)`",cb.get_name(), OBJ.get_full_name())) \
         return VAL; \
       end \
       `uvm_cb_trace_noobj(cb,$sformatf(`"Executed callback method 'METHOD' for callback %s (CB) from %s (T) : did not return value VAL`",cb.get_name(), OBJ.get_full_name())) \
       cb = iter.next(); \
     end \
     return 1-VAL; \
   end



`ifdef UVM_CB_TRACE_ON

`define uvm_cb_trace(OBJ,CB,OPER) \
  begin \
    string msg; \
    msg = (OBJ == null) ? "null" : $sformatf("%s (%s@%0d)", \
      OBJ.get_full_name(), OBJ.get_type_name(), OBJ.get_inst_id()); \
    `uvm_info("UVMCB_TRC", $sformatf("%s: callback %s (%s@%0d) : to object %s",  \
       OPER, CB.get_name(), CB.get_type_name(), CB.get_inst_id(), msg), UVM_NONE) \
  end

`define uvm_cb_trace_noobj(CB,OPER) \
  begin \
    if(uvm_callbacks_base::m_tracing) \
      `uvm_info("UVMCB_TRC", $sformatf("%s : callback %s (%s@%0d)" ,  \
       OPER, CB.get_name(), CB.get_type_name(), CB.get_inst_id()), UVM_NONE) \
  end
`else

`define uvm_cb_trace_noobj(CB,OPER) 
`define uvm_cb_trace(OBJ,CB,OPER) 

`endif


`endif



`ifndef UVM_REG_ADDR_WIDTH
 `define UVM_REG_ADDR_WIDTH 64
`endif


`ifndef UVM_REG_DATA_WIDTH
 `define UVM_REG_DATA_WIDTH 64
`endif


`ifndef UVM_REG_BYTENABLE_WIDTH 
  `define UVM_REG_BYTENABLE_WIDTH ((`UVM_REG_DATA_WIDTH-1)/8+1) 
`endif


`ifndef UVM_REG_CVR_WIDTH
 `define UVM_REG_CVR_WIDTH 32
`endif



`ifndef UVM_NO_DEPRECATED


`define m_uvm_register_sequence(TYPE_NAME, SEQUENCER) \
  static bit is_registered_with_sequencer = SEQUENCER``::add_typewide_sequence(`"TYPE_NAME`");


`define uvm_sequence_utils_begin(TYPE_NAME, SEQUENCER) \
  `m_uvm_register_sequence(TYPE_NAME, SEQUENCER) \
  `uvm_declare_p_sequencer(SEQUENCER) \
  `uvm_object_utils_begin(TYPE_NAME)

`define uvm_sequence_utils_end \
  `uvm_object_utils_end


`define uvm_sequence_utils(TYPE_NAME, SEQUENCER) \
  `uvm_sequence_utils_begin(TYPE_NAME,SEQUENCER) \
  `uvm_sequence_utils_end



`define uvm_declare_sequence_lib \
  protected bit m_set_sequences_called = 1;    \
  static protected string m_static_sequences[$]; \
  static protected string m_static_remove_sequences[$]; \
  \
  static function bit add_typewide_sequence(string type_name); \
    m_static_sequences.push_back(type_name); \
    return 1; \
  endfunction\
  \
  static function bit remove_typewide_sequence(string type_name); \
    m_static_remove_sequences.push_back(type_name); \
    for (int i = 0; i < m_static_sequences.size(); i++) begin \
      if (m_static_sequences[i] == type_name) \
        m_static_sequences.delete(i); \
    end \
    return 1;\
  endfunction\
  \
  function void uvm_update_sequence_lib();\
    if(this.m_set_sequences_called) begin \
      set_sequences_queue(m_static_sequences); \
      this.m_set_sequences_called = 0;\
    end\
    for (int i = 0; i < m_static_remove_sequences.size(); i++) begin \
      remove_sequence(m_static_remove_sequences[i]); \
    end \
  endfunction\




`define uvm_update_sequence_lib \
  m_add_builtin_seqs(0); \
  uvm_update_sequence_lib();



`define uvm_update_sequence_lib_and_item(USER_ITEM) \
  begin   uvm_coreservice_t cs = uvm_coreservice_t::get(); uvm_factory factory=cs.get_factory(); \
  factory.set_inst_override_by_type( \
    uvm_sequence_item::get_type(), USER_ITEM::get_type(), \
  {get_full_name(), "*.item"}); end \
  m_add_builtin_seqs(1); \
  uvm_update_sequence_lib();



`define uvm_sequencer_utils(TYPE_NAME) \
  `uvm_sequencer_utils_begin(TYPE_NAME) \
  `uvm_sequencer_utils_end


`define uvm_sequencer_utils_begin(TYPE_NAME) \
  `uvm_declare_sequence_lib \
  `uvm_component_utils_begin(TYPE_NAME)


`define uvm_sequencer_param_utils(TYPE_NAME) \
  `uvm_sequencer_param_utils_begin(TYPE_NAME) \
  `uvm_sequencer_utils_end


`define uvm_sequencer_param_utils_begin(TYPE_NAME) \
  `uvm_declare_sequence_lib \
  `uvm_component_param_utils_begin(TYPE_NAME)



`define uvm_sequencer_utils_end \
  `uvm_component_utils_end




`define uvm_package(PKG) \
  package PKG; \
  class uvm_bogus_class extends uvm::uvm_sequence;\
  endclass

`define uvm_end_package \
   endpackage



`define uvm_sequence_library_package(PKG_NAME) \
  import PKG_NAME``::*; \
  PKG_NAME``::uvm_bogus_class M_``PKG_NAME``uvm_bogus_class

`endif 

`endif