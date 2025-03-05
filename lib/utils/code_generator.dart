String codeGenerator(String type, String tp) {
  if (tp == "Commercial" && type == "Rent") {
    return "CR";
  }
  if (tp == "Commercial" && type == "Buy") {
    return "CS";
  }
  if (tp == "Plot_farmland" ){
    return "PR";
  }
  if (tp == "Rent" ){
    return "RR";
  }
  return "RS";
}

  // tp - > "Commercial", "Plot_farmland", "Rent", ""
  // type -> "Rent","Buy"