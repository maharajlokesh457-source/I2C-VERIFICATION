
//<===== TRANSACTION CLASS =====>
class transaction extends uvm_sequence_item
  bit newd;
  rand bit wr;
  rand bit[7:0] wdata;
  rand bit[7:0] addr;
  bit[7:0] rdata;
  bit done;
  constraint addr_range{ 
    addr >0;
    addr <5;
  }
  constraint wr_c_rd{
    wr dist{0:/50,1:/50};
  }
  function new(input string name = "TRANS");
    super.new(name);
  endfunction
  `uvm_object_utils_begin(transaction);
  `uvm_field_int(newd,UVM_DEFAULT);
  `uvm_field_int(wr,UVM_DEFAULT);
  `uvm_field_int(wdata,UVM_DEFAULT);
  `uvm_field_int(addr,UVM_DEFAULT);
  `uvm_field_int(rdata,UVM_DEFAULT);
  `uvm_field_int(done,UVM_DEFAULT);
  `uvm_obejct_utils_end
endclass

//<===== GENERATOR CLASS =====>
class generator extends uvm_sequence#(transaction);
  `uvm_object_utils(generator)
  transaction t;
  integer i;
  function new(input string name = "GEN");
    super.new(name);
  endfunction
  virtual task body;
     t = transaction::type_id::create("TRANS");
    for(i=0;1<5;i++)begin
      start_item(t);
      `uvm_info("NEW""=========="UVM_NONE);
      t.randomize();
      `uvm_info("GEN","Data is sending to driver",UVM_NONE);
      t.print(uvm_defaukt_line_printer)
      finish_item(t);
    end
  endtask
endclass

//<===== DRIVER CLASS =====>
class driver class uvm_driver#(transaction);
  `uvm_component_utils(driver)
  function new(input string name = "DRV",uvm_component c);
    super.new(name,c);
  endfunction
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t = transaction::type_id::create("TRANS");
    if(!uvm_config_db #(virtual i2c_if)::get(this,"","vif",vif))begin
      `uvm_fatal("DRV","Unable to connect db");
    end
  endfunction
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge clk);
      
    end
  endtask
endclass
