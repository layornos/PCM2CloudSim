import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.palladiosimulator.pcm.resourceenvironment.ResourceenvironmentPackage

class Main {
	static def registerEPackages(ResourceSet resourceSet) {
		resourceSet.getPackageRegistry().put(ResourceenvironmentPackage.eNS_URI, ResourceenvironmentPackage.eINSTANCE);
	}
	
	def static void main(String[] args) {
		registerEPackages(new ResourceSetImpl);
		val generator = new PCM2CloudSim
		generator.mainClassName = "MediaStoreSimulation"
		println(generator.loadResourceEnvironmentModel("models/ms.resourceenvironment"))	
	}
	
		
}