`ifndef TESTING
`define TESTING

`define DO_TEST(value, expected, name) \
if (value == expected) \
    $display("Passed (%s, %0d [%0d]): %s", `__FILE__, `__LINE__, $realtime, name); \
else \
    $display("Failed (%s, %0d [%0d]): %s", `__FILE__, `__LINE__, $realtime, name);

`endif
