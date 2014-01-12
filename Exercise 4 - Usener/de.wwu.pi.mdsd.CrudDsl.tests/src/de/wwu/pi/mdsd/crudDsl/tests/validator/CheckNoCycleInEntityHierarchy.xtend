package de.wwu.pi.mdsd.crudDsl.tests.validator

import de.wwu.pi.mdsd.crudDsl.CrudDslInjectorProvider
import de.wwu.pi.mdsd.crudDsl.crudDsl.CrudDslPackage
import de.wwu.pi.mdsd.crudDsl.crudDsl.CrudModel
import javax.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.runner.RunWith

import org.junit.Test
import static de.wwu.pi.mdsd.crudDsl.validation.CrudDslValidator.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(CrudDslInjectorProvider))
class CheckNoCycleInEntityHierarchy {
	@Inject extension ParseHelper<CrudModel>
	@Inject extension ValidationTestHelper

	@Test
	def void testCheckNoCycleInEntityHierarcy() {
		val model = '''
			package test.test
			
			entity A extends B {
			}
			
			entity B extends A {
			}
		'''
		model.parse.assertError(
			CrudDslPackage::eINSTANCE.entity,
			CYCLIC_ENTITY_HIERARCHY_ERROR,
			'B extends A'
		)

		model.parse.assertError(
			CrudDslPackage::eINSTANCE.entity,
			CYCLIC_ENTITY_HIERARCHY_ERROR,
			'A extends B'
		)
	}

	@Test
	def void testCheckNoCycleInEntityHierarcyNoError() {
		'''
			package test.test
			
			entity A {
			}
			
			entity B extends A {
			}
			
			entity C extends B {
			}
		'''.parse.assertNoErrors
	}
}
