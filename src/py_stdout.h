#include <Python.h>

namespace pyr {

PyMODINIT_FUNC PyInit_PyR(void);
PyObject *PyStream_FromStream(std::ostream *stream);
PyObject *set_stdstream(std::string name, PyObject *pystream);

}
