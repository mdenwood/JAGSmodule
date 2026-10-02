#include <stdlib.h>
#include <R_ext/Rdynload.h>
#include <Rinternals.h> // for SEXP

extern void testmodule(int *disttype, int *dpqr, int *uselog, int *lower, int *N, double *x, int *npars, double *parameters, double *values, int *status);

static R_NativePrimitiveArgType testmodule_t[] = {
    INTSXP, INTSXP, INTSXP, INTSXP, INTSXP, REALSXP, INTSXP, REALSXP, REALSXP, INTSXP
};

static const R_CMethodDef cMethods[] = {
    {"testmodule", (DL_FUNC) &testmodule, 10, testmodule_t},
    {NULL, NULL, 0, NULL}
};

void
R_init_JAGSmodule(DllInfo *dll)
{
    R_registerRoutines(dll, cMethods, NULL, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
