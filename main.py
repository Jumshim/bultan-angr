import angr
import monkeyhex
proj = angr.Project('exe', auto_load_libs=False)

print(proj.filename + " has been loaded into angr")
obj = proj.loader.main_object
print("The entry point of the project is " + str(obj.entry))
print(f"min address: {str(obj.min_addr)}, max address: {str(obj.max_addr)}")

cfg = proj.analyses.CFGFast()
print("This is the graph:", cfg.graph)
print("It has %d nodes and %d edges" % (len(cfg.graph.nodes()), len(cfg.graph.edges())))