import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.palladiosimulator.pcm.resourceenvironment.ResourceenvironmentPackage

class PCM2CloudSimGenerator {
	static ResourceSet loadResourceSet = new ResourceSetImpl();

	static def registerEPackages(ResourceSet resourceSet) {
		resourceSet.getPackageRegistry().put(ResourceenvironmentPackage.eNS_URI, ResourceenvironmentPackage.eINSTANCE);
	}
	
	def static void main(String[] args) {
		registerEPackages(loadResourceSet);
	}
}
