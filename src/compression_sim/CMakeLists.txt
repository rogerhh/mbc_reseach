add_executable(run_sim.exe run_sim.cpp log2.cpp Sim.cpp ../json11.cpp)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g3")
add_executable(run_sim_v2.exe run_sim_v2.cpp log2.cpp Sim_v2.cpp ../json11.cpp)
add_executable(huffman_tree_gen.exe huffman_tree_gen.cpp)
add_executable(run_compression_sim.exe run_compression_sim.cpp log2.cpp Sim.cpp ../json11.cpp)


