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
class CheckOppositesMatch {

	@Inject extension ParseHelper<CrudModel>
	@Inject extension ValidationTestHelper

	@Test
	def void testError() {
		val model = '''
			package test.test
			
			abstract entity A {
				ref bs : B[*] opposite=a
				ref bss : B[*] opposite=a  
				ref cs : C[*] opposite=a
			}
			
			abstract entity B extends A {
				ref a : A[1] opposite=bs
				ref a2 : A[1] opposite=bs 
			}
			
			entity C extends B {
				ref a : A[1] opposite=cs 
			}
		'''
		model.parse.assertError(
			CrudDslPackage::eINSTANCE.reference,
			REFERENCE_OPPOSITES_MATCH_ERROR,
			String::format(REFERENCE_OPPOSITES_MATCH_MESSAGE, 'bs', 'bss')
		)

		model.parse.assertError(
			CrudDslPackage::eINSTANCE.reference,
			REFERENCE_OPPOSITES_MATCH_ERROR,
			String::format(
				REFERENCE_OPPOSITES_MATCH_MESSAGE,
				'a',
				'a2'
			)
		)
	}

	@Test
	def void testCorrect() {
		'''
			package test.test
			
			abstract entity A {
			}
			
			abstract entity B extends A {
			}
			
			entity C extends B {
			}
		'''.parse.assertNoErrors
	}
}
