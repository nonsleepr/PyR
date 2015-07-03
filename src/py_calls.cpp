#include <Rcpp.h>

#include <Python.h>
#include <bytesobject.h>

#include "py_stream.h"

using namespace Rcpp;

#if PY_MAJOR_VERSION == 2
#define _PyString_AsString(obj) PyString_AsString((obj))
#else
#define _PyString_AsString(obj) PyUnicode_AsUTF8((obj))
#endif

PyObject *g_stdout = 0;
PyObject *g_stderr = 0;


// [[Rcpp::export(name = .python.init)]]
void py_init(std::string name = "") {
  Py_SetProgramName(const_cast<char*>(name.c_str()));
  PyImport_AppendInittab("pyr", pyr::PyInit_PyR);
  Py_Initialize();
  PyImport_ImportModule("pyr");
  // syncronized stdout/stderr
  // see http://gallery.rcpp.org/articles/using-rcout/
  g_stdout = pyr::set_stdstream(std::string("stdout"), pyr::PyStream_FromStream(&Rcpp::Rcout));
  g_stderr = pyr::set_stdstream(std::string("stderr"), pyr::PyStream_FromStream(&Rcpp::Rcerr));
}

// [[Rcpp::export(name = .python.close)]]
void py_close() {
  // Not sure if it works and we're really don't need it since we're closing
  // the session anyways.
  //pyr::set_stdstream(std::string("stdout"), g_stdout);
  //pyr::set_stdstream(std::string("stderr"), g_stderr);
  Py_Finalize();
}

RcppExport SEXP py_to_R(PyObject *obj) {
  if (!obj || obj == Py_None) {
    return R_NilValue;
  }

  if (PyInt_CheckExact(obj)) {
    return wrap(PyInt_AsLong(obj));
  } else if (PyLong_CheckExact(obj)) {
    return wrap(PyLong_AsLong(obj));
  } else if (PyFloat_CheckExact(obj)) {
    return wrap(PyFloat_AsDouble(obj));
  } else if (PyBool_Check(obj)) {
    return wrap(obj == Py_True);
  } else if (PyString_Check(obj)) {
  } else {
    obj = PyObject_Str(obj);
  }
  return wrap(std::string(_PyString_AsString(obj)));
}

//' Execute Python code and return results as a std::string.
//'
//' @param py_code std::string containing Python code.
//' @param start Execution mode.
//'   c("eval","file","single")
// [[Rcpp::export(name = .python.exec)]]
RcppExport SEXP py_exec(std::string py_code, std::string start = "single") {
  int start_token = 0;

  if (start == "eval") {
    start_token = Py_eval_input;
  } else if (start == "file") {
    start_token = Py_file_input;
  } else if (start == "single") {
    start_token = Py_single_input;
  }

  PyObject *module     = PyImport_AddModule("__main__");
  PyObject *dictionary = PyModule_GetDict(module);
  PyObject *result     = PyRun_String(py_code.c_str(), start_token, dictionary, dictionary);

  if (PyErr_Occurred()) {
    // Handle exception
    PyErr_Print();
    PyErr_Clear();
    Rf_error("Python exception");
    return R_NilValue;
  }

  // TODO: parse results to get rid of jsonlite
  //return py_to_R(result);
  if (!result || result == Py_None) {
    return R_NilValue;
  }
  return wrap(std::string(_PyString_AsString(PyObject_Str(result))));

}

/*
// [[Rcpp::export]]
RcppExport SEXP py_get_type(std::string var_name) {
  PyObject *module     = PyImport_AddModule("__main__");
  PyObject *dictionary = PyModule_GetDict(module);
  PyObject *result     = PyDict_GetItemString(dictionary, var_name.c_str());

  if (!result) {
    return R_NilValue;
  }
  return wrap(Py_TYPE(result)->tp_name);
}
*/

//' Get value of Python variable.
//'
//' @param var_name Variable name string.
//' @return Value of the variable.
//' @examples
//' python.get('a')
// [[Rcpp::export(name = python.get)]]
RcppExport SEXP py_get(std::string var_name) {
  PyObject *module     = PyImport_AddModule("__main__");
  PyObject *dictionary = PyModule_GetDict(module);
  PyObject *result     = PyDict_GetItemString(dictionary, var_name.c_str());

  return py_to_R(result);
}
