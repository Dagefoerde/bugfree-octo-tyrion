package de.wwu.pi.mdsd.crudDsl.tests.validator

import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import de.wwu.pi.mdsd.crudDsl.CrudDslInjectorProvider
import javax.inject.Inject
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.xtext.junit4.util.ParseHelper
import de.wwu.pi.mdsd.crudDsl.crudDsl.CrudModel
import org.junit.Test
import de.wwu.pi.mdsd.crudDsl.crudDsl.CrudDslPackage
import static de.wwu.pi.mdsd.crudDsl.validation.CrudDslValidator.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(CrudDslInjectorProvider))

class CheckAbstract {

	@Inject extension ParseHelper<CrudModel>
	@Inject extension ValidationTestHelper

	@Test
	def void testCheckNoCycleInEntityHierarcy() {
		val model = '''
			package test.test
			
			abstract entity A {}
			abstract entity B extends A {}
			abstract entity C extends B {}
			abstract entity D {}
		'''
		model.parse.assertError(
			CrudDslPackage::eINSTANCE.entity,
			ONLY_SUPERTYPES_ARE_ABSTRACT_ERROR,
			String::format(ONLY_SUPERTYPES_ARE_ABSTRACT_MESSAGE, 'C')
		)
		
		model.parse.assertError(
			CrudDslPackage::eINSTANCE.entity,
			ONLY_SUPERTYPES_ARE_ABSTRACT_ERROR,
			String::format(ONLY_SUPERTYPES_ARE_ABSTRACT_MESSAGE, 'D')
		)
	}
		
	@Test
	def void testCorrect() {
		'''
		package test.test

		abstract entity A {
			ref bs : B[*] opposite=a
			ref bss : B[*] opposite=a2  
			ref cs : C[*] opposite=a3
		}
		
		abstract entity B extends A {
			ref a : A[1] opposite=bs
			ref a2 : A[1] opposite=bss 
		}
		
		entity C extends B {
			ref a3 : A[1] opposite=cs 
		}
		'''.parse.assertNoErrors
	}
}