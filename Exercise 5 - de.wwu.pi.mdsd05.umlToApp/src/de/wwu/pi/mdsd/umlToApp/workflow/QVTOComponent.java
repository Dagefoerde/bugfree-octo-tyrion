package de.wwu.pi.mdsd.umlToApp.workflow;

import java.io.File;
import java.util.List;

import org.eclipse.emf.common.util.Diagnostic;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.mwe.core.WorkflowContext;
import org.eclipse.emf.mwe.core.issues.Issues;
import org.eclipse.emf.mwe.core.lib.AbstractWorkflowComponent;
import org.eclipse.emf.mwe.core.monitor.ProgressMonitor;
import org.eclipse.m2m.qvt.oml.BasicModelExtent;
import org.eclipse.m2m.qvt.oml.ExecutionContext;
import org.eclipse.m2m.qvt.oml.ExecutionContextImpl;
import org.eclipse.m2m.qvt.oml.ModelExtent;
import org.eclipse.m2m.qvt.oml.TransformationExecutor;

public class QVTOComponent extends AbstractWorkflowComponent {
	private static final String COMPONENT_NAME = "QVTOComponent";

	protected String transformationFile;
	
	protected String modelSlot;

	public void setTransformationFile(String transformationUri) {
		this.transformationFile = transformationUri;
	}
	
	public void setModelSlot(String modelSlot) {
		this.modelSlot = modelSlot;
	}
	
	private TransformationExecutor exec;

	protected TransformationExecutor getExec() {
		if(exec == null){
			URI transformationUri = URI.createFileURI(new File(transformationFile).getAbsolutePath());
			exec = new TransformationExecutor(transformationUri);
		}
		return exec;
	}

	@Override
	public void checkConfiguration(Issues issues) {
		if(transformationFile == null){
			issues.addError(this, "transformationFile not specified.");
		}
	}

	@Override
	protected void invokeInternal(WorkflowContext ctx, ProgressMonitor monitor,
			Issues issues) {

		ModelExtent inputExtent = createInputModelExtent(ctx, issues);
		ModelExtent outputExtent = new BasicModelExtent();
		
		ExecutionContext context = new ExecutionContextImpl();
		Diagnostic result = getExec().execute(context, inputExtent, outputExtent);
		
		// the bitmask capacity of Diagnostic is not used - no need to consider it
		if(result.getSeverity() != Diagnostic.ERROR && result.getSeverity() != Diagnostic.CANCEL) {
			// Success (probably with warning)
			if(result.getSeverity() == Diagnostic.WARNING)
				issues.addWarning(this, "Transformation completed with warning: " + result.getMessage());
			
			handleModelExtent(ctx, outputExtent);
		}
		else {
			// Failure
			if(result.getSeverity() == Diagnostic.ERROR){
				issues.addError(this, "Transformation failure: " + transformationErrorMessage(result));
			}
			else
				issues.addError(this, "Transformation cancelled: " + result.getMessage());
		}
	}

	protected ModelExtent createInputModelExtent(WorkflowContext ctx, Issues issues) {
		ModelExtent result = new BasicModelExtent();
		
		Object slotContent = ctx.get(modelSlot);
		
		if(slotContent instanceof List) {
			@SuppressWarnings("rawtypes")
			List list = (List) slotContent;
			if(!list.isEmpty()) {
				if(list.get(0) instanceof Resource) {
					if(list.size() > 1)
						issues.addWarning(this, String.format("List in input slot '%s' contains more than one entry, ignoring all except the first", modelSlot));
					
					Resource resource = (Resource) list.get(0);
					result.setContents(resource.getContents());
				}
				else
					issues.addWarning(this, String.format("List in input slot '%s' does not contain resources", modelSlot));
			}
			else
				issues.addWarning(this, String.format("List in input slot '%s' was empty", modelSlot));
		}
		else
			issues.addWarning(this, String.format("Content of input slot '%s' was null or not a list.", modelSlot));
		
		return result;
	}

	protected void handleModelExtent(WorkflowContext ctx, ModelExtent cur) {
		@SuppressWarnings("unchecked") // types have been checked before in createModelExtent
		List<Resource> list = (List<Resource>) ctx.get(modelSlot);
		if(!list.isEmpty()) {
			Resource result = list.get(0);
			result.getContents().addAll(cur.getContents());
			ctx.set(modelSlot, result);
		}
	}
	
	protected String transformationErrorMessage(Diagnostic diag){
	    StringBuilder result = new StringBuilder(diag.getMessage());
	    
	    for(Diagnostic cur : diag.getChildren())
	        result.append("\n\t").append(cur.getMessage());
	    
	    return result.toString();
	}

	@Override
	public String getLogMessage() {
		return "Executing transformation " + transformationFile;
	}
	
	@Override
	public String getComponentName() {
		return COMPONENT_NAME;
	}
}
