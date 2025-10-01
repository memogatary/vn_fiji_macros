// This macro demonstrates how to use the
// Array.concat() macro function.

  print("original arrays");
  a = newArray("a1","a2","a3");
  Array.print(a);
  b = newArray("b1","b2","b3");
  Array.print(b);

  print("concatenated arrays");
  c = Array.concat(a, b);
  Array.print(c);

  print("add value to beginning of an array");
  a = Array.concat("xx", a);
  Array.print(a);

  print("add value to end of an array");
  b = Array.concat(b, "xx");
  Array.print(b);

  print("double the size of an array");
  a = newArray("a1","a2","a3");
  a = Array.concat(a, newArray(a.length));
  Array.print(a);


