import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.palladiosimulator.pcm.resourceenvironment.ResourceEnvironment
import org.palladiosimulator.pcm.resourceenvironment.ResourceenvironmentPackage
import java.util.List

class PCM2CloudSimGenerator {
	val RESOURCE_ENVIRONMENT = "resourceenvironment"
	var MAIN_CLASS = "MainClass"

	def setMainClassName(String name){
		this.MAIN_CLASS = name
	}
	
	def loadResourceEnvironmentModel(String fileName){
		
		val uri = URI.createFileURI(fileName)
		ResourceenvironmentPackage.eINSTANCE.eClass()
		
		var registry = Resource.Factory.Registry.INSTANCE
		var map = registry.extensionToFactoryMap
		map.put(RESOURCE_ENVIRONMENT, new XMIResourceFactoryImpl)
		
		var resSet = new ResourceSetImpl
		var resource = resSet.getResource(uri, true)
		EcoreUtil.resolveAll(resource)
		
		resource.load(null)
		
		return generateCode(resource.contents.get(0) as ResourceEnvironment)
	}
	
	def dispatch generateCode(ResourceEnvironment re) '''
	«imports»
	public class «MAIN_CLASS» {
		/** The cloudlet list. */
		private static List<Cloudlet> cloudletList;
		
		/** The vmlist. */
		private static List<Vm> vmlist;
		
		/** The VM's are « FOR p : re.resourceContainer_ResourceEnvironment SEPARATOR ', '»«p.entityName»«ENDFOR» */
		private static int number_of_vms = «re.resourceContainer_ResourceEnvironment.size»;
		
		/** The datacenter */
		private static int number_of_datacenters = 1;
		
		/** Main Method of «MAIN_CLASS» */
		public static void main(String[] args) {
			«log("\"Starting Simulation run of "+MAIN_CLASS+"...\"")»
			
			try{
				«initCloudSim»
				
				«createDatacenters»
				
	            «createBroker»
	            
	            «createVMs»
	            
	
			} catch (Exception e){
				e.printStackTrace(e);
			}
		}
	}
	'''
	
	def createVMs() '''
		vmlist = createIdenticalVMs(broker_id, 3, 0);
	'''
	
	def createBroker() '''
		// Creating Broker
		DatacenterBroker broker = createBroker("Broker_0");
		int broker_id = broker.getId();
	'''
	
	def createDatacenters() '''
	// Creating Datacenter(s)
	List<Datacenter> datacenters = new ArrayList<>();
	for(int i = 0; i < number_of_datacenters; i++) {
		datacenters.add(createDatacenter("Datacenter_"+i));
	}
	'''
  
 	def log(String s)'''
 		Log.printLine(«s»);
 	'''
 	
 	def initCloudSim()'''
 	int number_of_cloud_users = 1; // Number of Cloud Users -> Mapping unclear
 	Calendar calendar = Calendar.getInstance();
 	boolean trace_flag = false;
 	
 	CloudSim.init(number_of_cloud_users,calendar,trace_flag);
 	'''
 	
 	def imports()'''
 	import org.cloudbus.cloudsim.*;
 	import org.cloudbus.cloudsim.core.CloudSim;
 	import org.cloudbus.cloudsim.provisioners.BwProvisionerSimple;
 	import org.cloudbus.cloudsim.provisioners.PeProvisionerSimple;
 	import org.cloudbus.cloudsim.provisioners.RamProvisionerSimple;
 	import java.util.ArrayList;
 	import java.util.Calendar;
 	import java.util.LinkedList;
 	import java.util.List;
 	'''
 	
    
  


}
//
//  def static void main(String[] args) {
//    new PCM2CloudSim().generate("ms.resourceenvironment")
//  }
//

//


