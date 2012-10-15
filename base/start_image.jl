# set up non-serializable state
 reinit_stdio()
# restore shared library handles
_jl_lib = ccall(:jl_load_dynamic_library,Ptr{Void},(Ptr{None},),C_NULL)
@unix_only _jl_repl = _jl_lib
@windows_only _jl_repl = ccall(:jl_wrap_raw_dl_handle,Ptr{Void},(Ptr{Void},),ccall(:GetModuleHandleA,stdcall,Ptr{Void},(Ptr{Void},),C_NULL))

# Set up envrionment variables
@windows_only setenv("JL_ANSWER_COLOR","normal",false)

# Essential libraries
libpcre = dlopen("libpcre")
libgrisu = dlopen("libgrisu")
_jl_libm = dlopen("libopenlibm")
_jl_libfdm = dlopen("libopenlibm")
librandom = dlopen("librandom")
@windows_only advapi32 = dlopen("Advapi32")

# Optional libraries
const libblas = dlopen(libblas_name)
const liblapack = (libblas_name == liblapack_name) ? libblas : dlopen(liblapack_name)
@unix_only begin
    const libfftw = dlopen("libfftw3_threads")
    const libfftwf = dlopen("libfftw3f_threads")
end
@windows_only begin
    const libfftw = dlopen("libfftw3") #On MinGw FFTW must be built with integrated threads
    const libfftwf = dlopen("libfftw3f")
end

##_jl_libglpk = dlopen("libglpk")
##_jl_libglpk = dlopen("libglpk_wrapper")
