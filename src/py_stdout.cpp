#include <Python.h>

#include <iostream>

// from https://github.com/mloskot/workshop/blob/master/python/emb/emb.cpp
namespace pyr {

struct PyStream {
  PyObject_HEAD
  std::ostream *stream;
};

PyObject* PyStream_write(PyObject* self, PyObject* args) {
  std::size_t written(0);
  PyStream* selfimpl = reinterpret_cast<PyStream*>(self);
  if (selfimpl->stream) {
    char* data;
    if (!PyArg_ParseTuple(args, "s", &data))
      return 0;

    std::string str(data);
    *(selfimpl->stream) << str << std::endl;
    written = str.size();
  }
  return PyLong_FromSize_t(written);
}

PyObject* PyStream_flush(PyObject* self, PyObject* args) {
  // no-op
  return Py_BuildValue("");
}

PyMethodDef PyStream_methods[] = {
  {"write", PyStream_write, METH_VARARGS, "sys.PyStream.write"},
  {"flush", PyStream_flush, METH_VARARGS, "sys.PyStream.flush"},
  {0, 0, 0, 0} // sentinel
};

PyTypeObject PyStreamType = {
  PyVarObject_HEAD_INIT(0, 0)
  "PyR.PyStreamType",     /* tp_name */
  sizeof(PyStream),       /* tp_basicsize */
  0,                    /* tp_itemsize */
  0,                    /* tp_dealloc */
  0,                    /* tp_print */
  0,                    /* tp_getattr */
  0,                    /* tp_setattr */
  0,                    /* tp_reserved */
  0,                    /* tp_repr */
  0,                    /* tp_as_number */
  0,                    /* tp_as_sequence */
  0,                    /* tp_as_mapping */
  0,                    /* tp_hash  */
  0,                    /* tp_call */
  0,                    /* tp_str */
  0,                    /* tp_getattro */
  0,                    /* tp_setattro */
  0,                    /* tp_as_buffer */
  Py_TPFLAGS_DEFAULT,   /* tp_flags */
  "PyR.PyStream objects", /* tp_doc */
  0,                    /* tp_traverse */
  0,                    /* tp_clear */
  0,                    /* tp_richcompare */
  0,                    /* tp_weaklistoffset */
  0,                    /* tp_iter */
  0,                    /* tp_iternext */
  PyStream_methods,       /* tp_methods */
  0,                    /* tp_members */
  0,                    /* tp_getset */
  0,                    /* tp_base */
  0,                    /* tp_dict */
  0,                    /* tp_descr_get */
  0,                    /* tp_descr_set */
  0,                    /* tp_dictoffset */
  0,                    /* tp_init */
  0,                    /* tp_alloc */
  PyType_GenericNew,    /* tp_new */
};

PyMODINIT_FUNC PyInit_PyR(void) {
  if (PyType_Ready(&PyStreamType) < 0) {
    return;
  }

  //PyObject *mod = PyModule_New("pyr");
  PyObject *mod = Py_InitModule("pyr", NULL);
  if (mod) {
    Py_INCREF(&PyStreamType);
    //PyModule_AddObject(mod, "PyStream", (PyObject *)&PyStreamType);
  }
}

PyObject *PyStream_FromStream(std::ostream *stream) {
  PyObject *pystream = PyStreamType.tp_new(&PyStreamType, 0, 0);
  PyStream* impl = reinterpret_cast<PyStream*>(pystream);
  impl->stream = stream;
  return pystream;
}

PyObject *set_stdstream(std::string name, PyObject *pystream) {
  PyObject *old_pystream = PySys_GetObject(const_cast<char*>(name.c_str())); // borrowed
  Py_XINCREF(pystream);
  PySys_SetObject(const_cast<char*>(name.c_str()), pystream);
  Py_XDECREF(old_pystream);
  return old_pystream;
}

} // end namespace
